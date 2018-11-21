###############################################################################
#
# Used for performing meta-analysis in "A decade of test-retest reliability of
# functional connectivity: a systematic review and meta-analysis"
#
###############################################################################

install.packages("metafor")
install.packages("mixtools")
install.packages("gdata")
library(metafor)
library(mixtools)
library(gdata)

######### SETUP #########

# Define files
data_path="~/"
data_filename=paste(data_path,"detailed summary.xlsx",sep="")
forest_plot_filename=paste(data_path,"forest.pdf",sep="")
funnel_plot_filename=paste(data_path,"funnel.pdf",sep="")
mix_plot_filename=paste(data_path,"density.pdf",sep="")

# Import data
d=read.xls(data_filename, sheet=2, skip=1)
mydat=d[,c("Authors","Subjects","Year","Duration..min.","Repetition..sessions.","Anatomical.Scope","ICC.Type","ICC.Mean","ICC.SD")]
mydat$ICC.Var=mydat$ICC.SD^2

# Simple data summary
m=median(mydat$Subjects); i=IQR(mydat$Subjects)/2; m; m-i/2; m+i/2
m=median(mydat$Repetition..sessions.); i=IQR(mydat$Repetition..sessions.); m; m-i/2; m+i/2
m=median(mydat$Duration..min.); i=IQR(mydat$Duration..min.); m; m-i/2; m+i/2

######### META-ANALYSIS #########
# Estimate ICC
# http://www.metafor-project.org/doku.php/plots
# weighting via Hunter-Schmidt - http://www.metafor-project.org/doku.php/tips:hunter_schmidt_method

# Estimate as correlation via metafor
resMeta<-rma(ri=ICC.Mean,ni=Repetition..sessions.*Subjects,data=mydat,measure="COR",method="HS")

# Estimate as arithmetic mean
weight=mydat$Repetition..sessions.*mydat$Subjects
wm<-weighted.mean(mydat$ICC.Mean, weight) # mean
weighted.mean(abs(mydat$ICC.Mean-wm), weight) # SD of mean
wm_sd<-weighted.mean(mydat$ICC.SD, weight) # SD
weighted.mean(abs(mydat$ICC.SD-wm_sd), weight) # SD of SD

# Report & visualize meta results
summary(resMeta)

# Forest plot
pdf(forest_plot_filename) 
forest(resMeta,slab=paste(mydat$Authors,mydat$Year,sep=", "))
dev.off()

# Estimate publication bias
regtest(resMeta) # funnel regression 
ranktest(resMeta) # funnel rank regression

pdf(funnel_plot_filename) 
funnel(resMeta)
dev.off()

######### MIXTURE MODEL #########
# https://www.r-bloggers.com/fitting-mixture-distributions-with-the-r-package-mixtools/

# Fit Gaussian Mixture Model
resMix <- normalmixEM(mydat$ICC.Mean)

# Report mixture results
summary(resMix)

# Simple Kolmogorov-Smirnov test
# https://stats.stackexchange.com/questions/28873/goodness-of-fit-test-for-a-mixture-in-r
pmnorm <- function(x, mu, sigma, pmix) {
  pmix[1]*pnorm(x,mu[1],sigma[1]) + (1-pmix[1])*pnorm(x,mu[2],sigma[2])
}
KStest <- ks.test(mydat$ICC.Mean, pmnorm, mu=resMix$mu, sigma=resMix$sigma, pmix=resMix$lambda)
KStest

# Visualize mixture results
pdf(mix_plot_filename) 
plot(resMix,whichplots=2,xlim=c(0,0.6))  # histogram + estimated mixture densities
lines(density(mydat$ICC.Mean), lty=2, lwd=2) # histogram density
dev.off()

# Cite
citation()
citation("metafor")
citation("mixtools")
citation("gdata")
