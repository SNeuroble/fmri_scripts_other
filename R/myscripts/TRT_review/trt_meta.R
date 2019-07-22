###############################################################################
#
# Used for performing quantitative summary and meta-analysis in Noble et al.
# "A decade of test-retest reliability of functional connectivity: a systematic
# review and meta-analysis"
#
###############################################################################

##### INSTALL LIBRARIES #####

# install.packages("metafor")
# install.packages("mixtools")
# install.packages("gdata")
# install.packages("foreach")
library(metafor)
library(mixtools)
library(gdata)
library(foreach)

##### DEFINE FUNCTIONS #####

# ICC variance approximation for ICC(1,1)
# k is number observations of each object, n is number objects
# assumes normality (this becomes worse closer to 1)
# Reference: Shoukri et al., 2016 - Bias and Mean Square Error of Reliability Estimators under the One and Two Random Effects Models: The Effect of Non-Normality http://file.scirp.org/Html/5-1240660_65865.htm
# This references Eqn 6.1 in Donner 1986 (A Review of Inference Procedures for the Intraclass Correlation Coefficient in the One-Way Random Effects Model)
calc_icc_var <- function(icc,n,k) {
  return(  2 * (1-icc)^2 * ( 1 + (n-1) * icc )^2 / ( k * n * (n-1) )  )
}

######### SETUP #########

# Define files
data_path <- "/Volumes/GoogleDrive/My Drive/Steph - Lab/TRT Review/literature/culling papers"
figs_path <- "/Volumes/GoogleDrive/My Drive/Steph - Lab/TRT Review/figures"
data_filename <- paste(data_path,"/2 for meta and review.xlsx",sep="")
forest_plot_filename <- paste(figs_path,"/forest.pdf",sep="")
funnel_plot_filename <- paste(figs_path,"/funnel.pdf",sep="")
mix_plot_filename <- paste(figs_path,"/density.pdf",sep="")

# Import data
d <- read.xls(data_filename, sheet=2, skip=1)
mydat <- d[,c("Authors","Dataset","Subjects","Year","Duration..min.","Inter.Session.Interval","Repetition..sessions.","Anatomical.Scope","Node.Resolution","ICC.Type","ICC.Mean","ICC.SD")]

# Parse variables for moderator analysis
# - define anatomical scope
levels(mydat$Anatomical.Scope)[!(levels(mydat$Anatomical.Scope)=='WB' | levels(mydat$Anatomical.Scope)=='DMN')] <- 'Mix' # change to WB, DMN, or mix
# - redefine scan duration if using average measures
mydat[c(mydat$Authors=="Shah et al."),"Duration..min."] <- mydat[c(mydat$Authors=="Shah et al."),"Duration..min."]*4
mydat[c(mydat$Authors=="Lin et al."),"Duration..min."] <- mydat[c(mydat$Authors=="Lin et al."),"Duration..min."]*3
# - extract inter-session intervals
temp <- vector(mode = "list", length = length(mydat$Inter.Session.Interval))
for (i in 1:length(mydat$Inter.Session.Interval)) {
  t <- strsplit(as.character(mydat$Inter.Session.Interval[i])," \\(")
  temp[i]<-t[[1]][1]
}
mydat$Inter.Session.Interval <- as.factor(unlist(temp))
mydat$Inter.Session.Interval[which(mydat$Inter.Session.Interval=="<not given>")]=NA
mydat$Inter.Session.Interval[which(mydat$Inter.Session.Interval=="medium-mixed")]=NA

######## STUDY CHARACTERISTICS #########

# Summarize numerical study characteristics
for (category in c('Subjects','Repetition..sessions.','Duration..min.','ICC.Mean')) {
  m <- median(mydat[,category]);
  i <- IQR(mydat[,category])/2;
  r <- range(mydat[,category]);
  min <- min(mydat[,category]);
  max <- max(mydat[,category]);
  print(paste(category,' Summary: Median=',m,', IQR=',m-i/2,' - ',m+i/2,', range=',r[1],' - ',r[2],', min=',min,', max=',max,sep=""))
}

######### META-ANALYSIS #########

# Estimate ICC variance
mydat$ICC.Var_Est <- foreach(i=1:nrow(mydat), .combine = 'rbind') %do% calc_icc_var(mydat$ICC.Mean[i], mydat$Subjects[i], mydat$Repetition..sessions.[i])

# Meta-analysis: pooled estimate of ICC nested by dataset
# nesting reference: https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/fitting-a-three-level-model.html
resMeta <- rma.mv(ICC.Mean, ICC.Var_Est, data=mydat,
                random = list( ~1 | Dataset ),
                method="REML")
print(summary(resMeta))

# Estimate as arithmetic mean
study_weights <- mydat$Repetition..sessions.*mydat$Subjects
for (category in c('ICC.Mean','ICC.SD')) {
  wm <- weighted.mean(mydat[,category], study_weights, na.rm=T)
  sd <- weighted.mean(abs(mydat[,category]-wm), study_weights, na.rm=T)
  print(paste(category,': weighted mean=',wm,', SD=',sd,sep=""))
}

######### VISUALIZATION #########

# Forest plot
pdf(forest_plot_filename)
forest(resMeta, slab=paste(mydat$Authors,mydat$Year,sep=", ")) 
op <- par(cex = 1, font = 2)
text(-1.8, 27.1, "Authors and Year", pos = 4)
text(2.6,27.1, "ICC [95% CI]", pos = 2)
par(op)
dev.off()

# Funnel plot
pdf(funnel_plot_filename) 
funnel(resMeta)
dev.off()

# Estimate publication bias via funnel plot asymmetry
print(ranktest(resMeta))

######### EXPLORATORY ANALYSES #########

# 1. Exploratory meta-analysis with moderation by study characteristics (one at a time)
metaMods <- colnames(mydat[,2:10])
for (category in metaMods) {
  resMeta_mods <- rma.mv(ICC.Mean, ICC.Var_Est, mods = cbind(get(category)), data=mydat,
                       random = list( ~1 | Dataset ),
                       method="REML")
  print(paste(category,' p value: ', resMeta_mods$pval[2],' beta: ', resMeta_mods$beta[2],sep=""))
}


# 2. Fit Gaussian Mixture Model
# https://www.r-bloggers.com/fitting-mixture-distributions-with-the-r-package-mixtools/

resMix <- normalmixEM(mydat$ICC.Mean)

# Report mixture results
print(summary(resMix))

# Simple Kolmogorov-Smirnov test
# https://stats.stackexchange.com/questions/28873/goodness-of-fit-test-for-a-mixture-in-r
pmnorm <- function(x, mu, sigma, pmix) {
  pmix[1]*pnorm(x,mu[1],sigma[1]) + (1-pmix[1])*pnorm(x,mu[2],sigma[2])
}
KStest <- ks.test(mydat$ICC.Mean, pmnorm, mu=resMix$mu, sigma=resMix$sigma, pmix=resMix$lambda)
print(KStest)

# Visualize mixture results
pdf(mix_plot_filename) 
plot(resMix,whichplots=2,xlim=c(0,0.6))  # plot 2 = histogram + estimated mixture densities
lines(density(mydat$ICC.Mean), lty=2, lwd=2) # add histogram density
dev.off()

######### CITATIONS #########

citation()
citation("metafor")
citation("mixtools")
citation("gdata")



