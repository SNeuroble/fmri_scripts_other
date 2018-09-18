# linear regression w max likelihood

# first install lavaan
#install.packages("lavaan", dependencies = TRUE)#library(lavaan)
# get data (copy to clipboard)
# mydata <- read.delim(pipe("pbpaste"))


mymodel <- '
  # regressions
    #FOOT + HAND + TONGUE ~ WAIS + SIM + VOC + COMP + DSP + Wrat.word + Word.Attack + BNT + DK.stroop.1 + DK.stroop.2 + DK.stroop.3 + DK.stroop.4
    FOOT ~ DK.stroop.1 + DK.stroop.2 + DK.stroop.3 + DK.stroop.4
'

fit <- sem(mymodel, data=mydata)
summary(fit, standardized=TRUE)

parameterEstimates(fit)
