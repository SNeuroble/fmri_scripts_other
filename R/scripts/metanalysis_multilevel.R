# metaanalysis
# learning R: https://cran.r-project.org/doc/contrib/Lemon-kickstart/
# install.packages("metafor")
# library(metafor)


dat <- get(data(dat.konstantopoulos2011))
# head(dat, 15)

# descriptives
round(c(summary(dat$yi), SD=sd(dat$yi)), 2)

# effect size per district
round(aggregate(yi ~ district, data=dat, FUN=function(x) c(mean=mean(x), sd=sd(x), min=min(x), max=max(x))), 3)


# two level model
res <- rma(yi, vi, data=dat)
#res <- rma(yi, vi, mods = ~ I(year-mean(year)), data=dat)
res <- rma.mv(yi, vi, random = ~ 1 | study, data=dat)

res.ml <- rma.mv(yi, vi, random = ~ 1 | district/study, data=dat)

# year does not moderate
print(res, digits=3)











 