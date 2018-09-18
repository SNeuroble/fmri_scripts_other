library(lavaan)

covmat= '
54.85202987
0.65747427 0.39252442
7.60342806 3.81961925e-03 5.72970207
'

dat.cov <- getCov(covmat, names=c("X","M", "Y"))


# TPR FPR cov:[[  5.72970207   7.60342806]
 # [  7.60342806  54.85202987]]
# TPR sm cov:[[  5.72970207e+00   3.81961925e-03]
 # [  3.81961925e-03   3.92524418e-01]]
# FPR sm cov:[[ 54.85202987   0.65747427]
 # [  0.65747427   0.39252442]]
# obs:50940

##Mediation
model <- ' # direct effect
             Y ~ c*X
           # mediator
             M ~ a*X
             Y ~ b*M
           # indirect effect (a*b)
             ab := a*b
           # total effect
             total := c + (a*b)
         '
fit <- sem(model, sample.cov = dat.cov, sample.nobs=50940)
summary(fit)
parameterEstimates(fit, standardized=T)

##Reverse Mediation
model <- ' # direct effect
             M ~ c*X
           # mediator
             Y ~ a*X
             M ~ b*Y
           # indirect effect (a*b)
             ab := a*b
           # total effect
             total := c + (a*b)
         '
fit <- sem(model, sample.cov = dat.cov, sample.nobs=50940)
summary(fit)
