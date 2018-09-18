setupdatanames <- function(titles_origdata,titles_newdata,data) {
# organize data

newdata <- data[,c(titles_origdata)]

halfdim=length(titles_newdata)

# always do first half A, second half D
colnames(newdata) <-  c((paste(paste('A',1:halfdim, sep=''), titles_newdata, sep=' ')),
(paste(paste('D',halfdim+1:2*halfdim,  sep=''), titles_newdata, sep=' ')))

return(newdata)
      
}