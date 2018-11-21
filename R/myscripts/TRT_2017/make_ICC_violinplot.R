make_ICC_violinplot <- function(data,thiscolor) {

list.of.packages <- c("ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
	install.packages(new.packages)
	lapply(new.packages, require, character.only = TRUE)
}

sz=0.9

p <- ggplot(data, aes(variable, value)) +

	geom_violin(trim=FALSE, fill=thiscolor) +
	# can also do fill=variable

	stat_summary(fun.data="mean_sdl",fun.args = list(mult = 1), 
	geom="pointrange", color="black" ) + 

	scale_y_continuous(limit = c(0, 1)) +

	geom_hline(yintercept=0.4,linetype=3,color="red",size=sz) +
	geom_hline(yintercept=0.6,linetype=3,color="green",size=sz) +
	geom_hline(yintercept=0.74,linetype=3,color="gold",size=sz) +

	scale_fill_brewer(palette="Spectral") +
	# scale_fill_brewer(palette="BuGn")

	ylab("ICC") + xlab("") +
	scale_x_discrete(labels=c("1", "2", "3", "4", "5", "6", "7", "8", "9")) +
	
	theme_classic(base_size = 18)
	# theme(axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"))
                      
print(p)
}