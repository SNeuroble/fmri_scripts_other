list.of.packages <- c("ggplot2", "reshape","dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
	install.packages(new.packages)
}
lapply(list.of.packages, library, character.only = TRUE)
# source('~/Documents/R/scripts/installggplot2developer.r')

source("Documents/R/scripts/make_ICC_violinplot2.R")



procedures=c("pcc","rmc","lt","icd","matrix")
#proc_colors=c("purple","red","yellow","green","blue")
dir="~/Documents/MATLAB/workspaces/trav/icc/Dstudy_imgs and iccs/singlesite/"
fileend1="_fullicc_5.txt"
fileend2="_fullicc_sig_5.txt"

for(thisprocedure in procedures)
{
	thisdata=paste(dir,thisprocedure,fileend1,sep="")
	a <- read.table(thisdata,sep=',')
	a <- melt(a)
	
	thisdata2=paste(dir,thisprocedure,fileend2,sep="")
	# thisdata2=paste(dir,procedures[i],fileend2,sep="")
	a2 <- read.table(thisdata2,sep=',')
	a2 <- melt(a2)
	
	imgdir="~/Documents/R/mydata/"
	thisimgfile=paste(imgdir,thisprocedure,'_violins.png',sep="")
	png(thisimgfile,width=1400,height=400)
	# make_ICC_violinplot2(a2,proc_colors[i],a2)
	make_ICC_violinplot2(a,a2)
	dev.off()
}