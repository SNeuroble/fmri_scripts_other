make_ICC_violinplot2 <- function(data1,data2) {
# make_ICC_violinplot2 <- function(data1,thiscolor) {
 
list.of.packages <- c("ggplot2","dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
	install.packages(new.packages)
}
lapply(list.of.packages, library, character.only = TRUE)
source("Documents/R/scripts/geom_flat_violin.R")

lcolor<-"gray30"
lsz<-1.8
htrans<-0.9
hsz<-2 #hsz=0.9
moffset<-0.03 # means and errorbars offsets - shift right or left by changing x-grouping var to numeric and then adding the offset
mshape<-18 #mshape<-"."
msz<-1 #msz<-0.4
fsz<-35

p <- ggplot() +

	# geom_flat_violin(data=data1, aes(variable, value), trim=FALSE, fill="steelblue", color=lcolor, size=lsz) +
	# geom_flat_violin(data=data2, aes(variable, value), trim=FALSE, fill="lightseagreen", color=lcolor, size=lsz) +
	
	geom_flat_violin(data=data1, aes(variable, value), trim=FALSE, fill="lightcoral", color=lcolor, size=lsz) +
	geom_flat_violin(data=data2, aes(variable, value), trim=FALSE, fill="cyan3", color=lcolor, size=lsz) +
	# lightcolor
	
	
	# geom_flat_violin(trim=FALSE, fill=thiscolor) +
	# can also do fill=variable
	
	stat_summary(data=data1, aes(as.numeric(variable)-moffset, value), fun.data="mean_sdl",
	fun.args = list(mult = 1), geom="pointrange", color=lcolor, shape=mshape, size=msz) +
	
	stat_summary(data=data2, aes(as.numeric(variable)+moffset, value), fun.data="mean_sdl",
	fun.args = list(mult = 1), geom="pointrange", color=lcolor, shape=mshape, size=msz) + 

	scale_y_continuous(limit = c(-0.001, 1)) +

	#geom_hline(yintercept=0.4,linetype=3,color="black",alpha=htrans,size=hsz) +
	#geom_hline(yintercept=0.6,linetype=3,color="gray60",alpha= htrans,size=hsz) +
	#geom_hline(yintercept=0.74,linetype=3,color="gray80",alpha= htrans, size=hsz) +
	
	geom_hline(yintercept=0.4,linetype="dotted",color="red",alpha=htrans,size=hsz) +
	geom_hline(yintercept=0.6,linetype=3,color="lawngreen",alpha= htrans,size=hsz) +
	geom_hline(yintercept=0.74,linetype=3,color="gold",alpha=htrans, size=hsz) +

	scale_fill_brewer(palette="Spectral") +
	# scale_fill_brewer(palette="BuGn")

	ylab("ICC") + xlab("") +
	scale_x_discrete(labels=c("1", "2", "3", "4", "5", "6", "7", "8", "9")) +
	
	theme_classic(base_size=fsz)
	# theme(axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"))

print(p) 
}