

Data <- read.csv("~/Documents/R/testdata/matrix4.txt", header = FALSE)
head(Data, n=2)
diag(Data) <- 1
Data2 <- data.matrix(Data) # make matrix
Data3 <- Data2[1:20,1:20]

install.packages("psych")
library(psych)

# choice of factor analysis
# 1
factanal(factors=5, covmat = Data3, n.obs = 150, rotation="none")

# or 2
fa(r=Data3,nfactors=2,n.obs=268,fm='pa',rotate='varimax')


# data manipulation
Data[1:5,1:5] # display only these entries

# generate random data, do correlation
x<-matrix(rnorm(5*10),5,10)
x2<-cor(x,x)

# logical indexing?