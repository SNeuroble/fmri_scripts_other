# https://www.r-bloggers.com/partial-least-squares-in-r/

# Load caret, install if necessary
install.packages("caret")
library(caret)
arcene <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/arcene/ARCENE/arcene_train.data", sep = " ",
                     colClasses = c(rep("numeric", 10000), "NULL"))

# Add the labels as an additional column
arcene$class <- factor(scan("https://archive.ics.uci.edu/ml/machine-learning-databases/arcene/ARCENE/arcene_train.labels", sep = "\t"))

# Compile cross-validation settings
set.seed(100)
myfolds <- createMultiFolds(arcene$class, k = 5, times = 10)
control <- trainControl("repeatedcv", index = myfolds, selectionFunction = "oneSE")

# Train PLS model
mod1 <- train(class ~ ., data = arcene,
              method = "pls",
              metric = "Accuracy",
              tuneLength = 20,
              trControl = control,
              preProc = c("zv","center","scale"))

# Check CV profile
plot(mod1)




# PCA-DA
mod2 <- train(class ~ ., data = arcene,
              method = "lda",
              metric = "Accuracy",
              trControl = control,
              preProc = c("zv","center","scale","pca"))

# RF
mod3 <- train(class ~ ., data = arcene,
              method = "ranger",
              metric = "Accuracy",
              trControl = control,
              tuneGrid = data.frame(mtry = seq(10,.5*ncol(arcene),length.out = 6)),
              preProc = c("zv","center","scale"))



# Compile models and compare performance
models <- resamples(list("PLS-DA" = mod1, "PCA-DA" = mod2, "RF" = mod3))
bwplot(models, metric = "Accuracy")

plot(varImp(mod1), 10, main = "PLS-DA")
plot(varImp(mod2), 10, main = "PCA-DA")

mod1$preProcess
mod2$preProcess

