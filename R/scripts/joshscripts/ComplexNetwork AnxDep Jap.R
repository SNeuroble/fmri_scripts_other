list.of.packages <- c("qgraph","coin")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
	install.packages(new.packages)
	lapply(new.packages, require, character.only = TRUE)
}

source('~/Documents/R/scripts/setupdatanames.R')
source('~/Documents/R/scripts/makeADgraphs.R')

thisdata = read.csv('~/Documents/R/scripts/joshscripts/JapanData.csv',header = TRUE)

showsample=0
if (showsample==1) {
	head(thisdata)
}

attach(thisdata)


origdatacols=c("Oa1.frequency", "Oa2.severity", "Oa3.avoidance", "Oa4.work", "Oa5.relation", "Od1.frequency", "Od2.severity", "Od3.avoidance", "Od4.work", "Od5.relation")
newdatatitles=c("Frequency", "Severity", "Anhedonia", "Work", "Relationships")
AD1<-setupdatanames(origdatacols,newdatatitles,thisdata)

origdatacols=c("T2.Oa1.frequency", "T2.Oa2.severity", "T2.Oa3.avoidance", "T2.Oa4.work", "T2.Oa5.relation", "T2.Od1.frequency", "T2.Od2.severity", "T2.Od3.avoidance", "T2.Od4.work", "T2.Od5.relation" )
newdatatitles=c("Frequency", "Severity", "Anhedonia", "Work", "Relationships")
AD2<-setupdatanames(origdatacols,newdatatitles,thisdata)

makeADgraphs(AD1,AD2,newdatatitles)





# replaces this:
# {
# # consider working on setupdatanames
# AD1 <- thisdata[,c("Oa1.frequency", "Oa2.severity", "Oa3.avoidance", "Oa4.work", "Oa5.relation", "Od1.frequency", "Od2.severity", "Od3.avoidance", "Od4.work", "Od5.relation" )]
# AD2 <- thisdata[,c("T2.Oa1.frequency", "T2.Oa2.severity", "T2.Oa3.avoidance", "T2.Oa4.work", "T2.Oa5.relation", "T2.Od1.frequency", "T2.Od2.severity", "T2.Od3.avoidance", "T2.Od4.work", "T2.Od5.relation" )]
# colnames(AD1) <-  c((paste(paste('A',1:5, sep=''), c("Frequency", "Severity", "Avoidance", "Work", "Relationships"), sep=' ')),
# (paste(paste('D',6:10,  sep=''), c("Frequency", "Severity", "Anhedonia", "Work", "Relationships"), sep=' ')))
# colnames(AD2) <-  c((paste(paste('A',1:5, sep=''), c("Frequency", "Severity", "Avoidance", "Work", "Relationships"), sep=' ')),
# (paste(paste('D',6:10,  sep=''), c("Frequency", "Severity", "Anhedonia", "Work", "Relationships"), sep=' ')))

# Groups <- rep(c('AnxSx','DepSx'),c(5,5))

# ##Graphs
# par(mfrow=c(1,2))
# Graph1 <- qgraph(sxCors1, layout = "spring", graph = "glasso", sampleSize = nrow(AD1),
      # groups = Groups, legend.cex = 0.3, title = "Figure 1. Time 1 Anxiety Depression Complex Network",
        # tuning = 0.5, maximum = 1, minimum = 0, esize = 5,
      # vsize = 5)

# Graph2 <- qgraph(sxCors2, layout = "spring", graph = "glasso", sampleSize = nrow(AD1),
      # groups = Groups, legend.cex = 0.3, title = "Figure 2. Time 2 Anxiety Depression Complex Network",
        # tuning = 0.5, maximum = 1, minimum = 0, esize = 5,
      # vsize = 5)
#}






# ## T1 Anxiety vs Depression
# #Strength
# cen.AD1 <- centrality(sxCors1)
# cent.AD1 <- centrality_auto(sxCors1)
# list.AD1.s <- cent.AD1$node.centrality$Strength
# list.s <- c(list.AD1.s)
# s <- data.frame(list.s,t = factor(rep(c("Anx","Dep"),c(5,5))))
# independence_test(list.s~t, data=s)
# t.test(list.s~t, data=s)








# # ##Homemade Permutation Test
# A<- list.s[1:5]
# B <- list.s[6:10]
# t.test(A,B)
# realized.dif = mean(B)-mean(A);  realized.dif  
# set.seed(6497)
# strength = stack(list(A=A, B=B))
# values    = strength$values
# ind       = strength$ind
# difs      = vector(length=1000)
# for(i in 1:1000){
  # ind     = sample(ind)
  # difs[i] = mean(values[ind=="B"])-mean(values[ind=="A"])
# }
# difs = sort(difs)
# mean(difs>=realized.dif)      # a 1-tailed test, if Ha: B>A a-priori
# mean(difs>=realized.dif)*2    # a 2-tailed test


# ### if realized.diff is positive then use >= # if realized.diff is negative then use <= to correspond to proper sign

# #closeness
# list.AD1.c <- cent.AD1$node.centrality$Closeness
# list.c <- c(list.AD1.c)
# s <- data.frame(list.c,t = factor(rep(c("Anx","Dep"),c(5,5))))
# independence_test(list.c~t, data=s)
# t.test(list.c~t, data=s)

# ## T2 Anxiety vs Depression
# #Strength
# cen.AD2 <- centrality(sxCors2)
# cent.AD2 <- centrality_auto(sxCors2)
# list.AD2.s <- cent.AD2$node.centrality$Strength
# list.s <- c(list.AD2.s)
# s <- data.frame(list.s,t = factor(rep(c("Anx","Dep"),c(5,5))))
# independence_test(list.s~t, data=s)
# t.test(list.s~t, data=s)

# #closeness
# list.AD2.c <- cent.AD2$node.centrality$Closeness
# list.c <- c(list.AD2.c)
# s <- data.frame(list.c,t = factor(rep(c("Anx","Dep"),c(5,5))))
# independence_test(list.c~t, data=s)
# t.test(list.c~t, data=s)

# ### T1 vs T2
# ##Strength
# list.s <- c(list.AD1.s, list.AD2.s)
# s <- data.frame(list.AD1.s, list.AD2.s)
# wilcoxsign_test(list.AD1.s[6:10]~ list.AD2.s[6:10], data=s, distribution="exact")
# t.test(list.AD1.s[6:10], list.AD2.s[6:10], data=s,paired=T)

# ##Closeness
# s <- data.frame(list.AD1.c, list.AD2.c)
# wilcoxsign_test(list.AD1.c[1:5]~ list.AD2.c[1:5], data=s, distribution="exact")
# t.test(list.AD1.c[1:5], list.AD2.c[1:5], data=s,paired=T)
# ########Distress Tolerance

# AD1 <- thisdata[,c("Oa1.frequency", "Oa2.severity", "Oa3.avoidance", "Oa4.work", "Oa5.relation", "Od1.frequency", "Od2.severity", "Od3.avoidance", "Od4.work", "Od5.relation", "T1SDISS" )]
# AD2 <- thisdata[,c("T2.Oa1.frequency", "T2.Oa2.severity", "T2.Oa3.avoidance", "T2.Oa4.work", "T2.Oa5.relation", "T2.Od1.frequency", "T2.Od2.severity", "T2.Od3.avoidance", "T2.Od4.work", "T2.Od5.relation", "T2SDISS" )]
# colnames(AD1) <- c((paste(paste('A',1:5, sep=''), c("Frequency", "Severity", "Avoidance", "Work", "Relationships"), sep=' ')),
# (paste(paste('D',6:10,  sep=''), c("Frequency", "Severity", "Anhedonia", "Work", "Relationships"), sep=' ')),"DT")
# colnames(AD2) <-  c((paste(paste('A',1:5, sep=''), c("Frequency", "Severity", "Avoidance", "Work", "Relationships"), sep=' ')),
# (paste(paste('D',6:10,  sep=''), c("Frequency", "Severity", "Anhedonia", "Work", "Relationships"), sep=' ')),"DT")


# Groups <- rep(c('AnxSx','DepSx', 'DT'),c(5,5,1))
# sxCors1 <- cor_auto(AD1)
# sxCors2 <- cor_auto(AD2)
# ##Graphs
# par(mfrow=c(1,2))
# Graph1 <- qgraph(sxCors1, layout = "spring", graph = "glasso", sampleSize = nrow(AD1),
      # groups = Groups, legend.cex = 0.3, title = "Figure 1. Time 1 Anxiety Depression Complex Network",
        # tuning = 0.5, maximum = 1, minimum = 0, esize = 5,
      # vsize = 5)
# Graph2 <- qgraph(sxCors2, layout = "spring", graph = "glasso", sampleSize = nrow(AD1),
      # groups = Groups, legend.cex = 0.3, title = "Figure 2. Time 2 Anxiety Depression Complex Network",
        # tuning = 0.5, maximum = 1, minimum = 0, esize = 5,
      # vsize = 5)

# ###DT cor with Anx vs Dep T1 

# #Not Appropriate because uses original correlation matrix     
# #C1 <- sxCors1[11,1:10]
# #list.s <- c(C1)
# #s <- data.frame(list.s,t = factor(rep(c("Anx","Dep"),c(5,5))))
# #independence_test(list.s~t, data=s, paired=T)
# #t.test(list.s~t, data=s)

# #Uses Edges after glasso
# C1 <- Graph1$Edgelist$weight[36:42]
# list.s <- c(C1)
# s <- data.frame(list.s,t = factor(rep(c("Anx","Dep"),c(4,3))))
# independence_test(list.s~t, data=s)
# t.test(list.s~t, data=s)

# ###DT cor with Anx vs Dep T2
# C2 <- Graph2$Edgelist$weight[36:42]
# list.s <- c(C2)
# s <- data.frame(list.s,t = factor(rep(c("Anx","Dep"),c(4,3))))
# independence_test(list.s~t, data=s)
# t.test(list.s~t, data=s)

# ### Compare Individual Edges ### #5 (anx interference) with DT gets sig stronger over time
# fisher.z<- function (r1,r2,n1,n2) (atanh(r1) - atanh(r2)) / ((1/(n1-3))+(1/(n2-3)))^0.5
# z <- fisher.z(r1= ,r2= ,n1= ,n2= )
# 2*(1-pnorm(abs(z)))

# sapply(seq(7), function(x) c(fisher.z(r1=C1[x], r2=C2[x], n1=nrow(AD1), n2=nrow(AD2)),2*(1-pnorm(abs(fisher.z(r1=C1[x], r2=C2[x], n1=nrow(AD1), n2=nrow(AD2)))))))

# ####NetworkComparisonTest
# library(githubinstall)
# githubinstall("NetworkComparisonTest")
# library(NetworkComparisonTest)

# ##Making new column names for AD1 and AD2 (including DT)
# paste('V',1:11, sep='')
# colnames(AD1) <- c(paste('V',1:11, sep=''))
# colnames(AD2) <- c(paste('V',1:11, sep=''))

# CAD1 <- na.omit(AD1)
# CAD2 <- na.omit(AD2)

# CAD1 <- AD1[complete.cases(AD2),]
# CAD2 <- AD2[complete.cases(AD2),]

# compare1 <- NCT(CAD1, CAD2, gamma=0.5, it=1000, binary.data=F, test.edges=T, edges=list(c(5,11), c(5,11)), paired=T) 


# #####Bootnet
# library(bootnet)
# ##Time1 noDT
# BGraph1<- bootnet(AD1, nBoots = 1000, default = "EBICglasso", type = "nonparametric") 
# plot(BGraph1, "strength", labels = T, plot= "area", order = "sample", CIstyle= "quantiles", decreasing=TRUE)   
# summary(BGraph1,"strength")

# ##Time2 noDT
# BGraph2<- bootnet(AD2, nBoots = 1000, default = "EBICglasso", type = "nonparametric") 
# plot(BGraph2, "strength", labels = T, plot= "area", order = "sample", CIstyle= "quantiles", decreasing=TRUE)   
# summary(BGraph2,"strength")

