# http://www.sthda.com/english/wiki/ggplot2-violin-plot-quick-start-guide-r-software-and-data-visualization

install.packages("ggplot2")
library("ggplot2")

# get data - either ToothGrowth or generate random
# p <- ggplot(ToothGrowth, aes(x=factor(dose), y=len)) + 
  # geom_violin()

# generate random data frame
ngroups <- 3
nobs <- 100
connectivity<-c(rnorm(ngroups*nobs))
groupnum <- rep(c(1:ngroups), each=nobs)
conn = data.frame(groupnum, connectivity)
conn$groupnum <- as.factor(conn$groupnum)
# can also test without making factors to make gradient colors

# plot
p <- ggplot(conn, aes(groupnum, connectivity, fill=groupnum)) +
	geom_violin(trim=FALSE)

p <- p + stat_summary(fun.data="mean_sdl",fun.args = list(mult = 1), 
geom="pointrange", color="red" )

p <- p + scale_y_continuous(limit = c(0, 5))

p <- p + scale_fill_brewer(palette="Dark2")

p <- p + geom_hline(yintercept=0.4,linetype=3,color="blue")
p <- p + geom_hline(yintercept=0.6,linetype=3,color="green")
p <- p + geom_hline(yintercept=0.74,linetype=3,color="yellow")
p



# library(scales) # might need for scale_y_continuous

# more examples
# R shape lookup: http://www.cookbook-r.com/Graphs/Shapes_and_line_types/
# p + stat_summary(fun.y=mean, geom="point", shape=23, size=2)
# p + stat_summary(fun.y=median, geom="point", size=2, color="red")                
# p + stat_summary(fun.data="mean_sdl",fun.args = list(mult = 1), 
#                  geom="crossbar", width=0.2 )                 
# p + stat_summary(fun.data="mean_sdl",fun.args = list(mult = 1), 
#                  geom="pointrange", color="red")
# sjp.grpfrq(efc$e17age, 
           # efc$e16sex,
           # legendLabels = efc_labels[['e16sex']],
           # type="v",
           # barColor="brewer",
           # colorPalette="Pastel1",
           # axisTitle.y="Age of Elderly Dependent")
