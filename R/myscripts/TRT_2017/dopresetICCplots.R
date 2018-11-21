list.of.packages <- c("ggplot2", "reshape")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
	install.packages(new.packages)
	lapply(new.packages, require, character.only = TRUE)
}
source("Documents/R/scripts/make_ICC_violinplot.R")



procedures=c("pcc","rmc","lt","icd","matrix")
proc_colors=c("purple","red","yellow","green","blue")
dir="~/Documents/MATLAB/workspaces/trav/icc/Dstudy_imgs and iccs/detailed_n_5 inc_0.125/"
fileend="_fullicc.txt"
nproc=length(procedures)
nproc=1

for(i in 1:nproc)
{
thisdata=paste(dir,procedures[i],fileend,sep="")
a <- read.table(thisdata,sep=',')
a <- melt(a)

imgdir="~/Documents/R/mydata/"
thisimgfile=paste(imgdir,procedures[i],'_violins.png',sep="")
png(thisimgfile,width=700,height=200)
make_ICC_violinplot(a,proc_colors[i])
dev.off()
}