makeADgraphs <- function(data1,data2,newdatatitles) {
	
groupdim=length(newdatatitles)

thesegroups=rep(c('AnxSx','DepSx'),c(groupdim,groupdim))


title1="Figure 1. Time 1 Anxiety Depression Complex Network"
title2="Figure 2. Time 2 Anxiety Depression Complex Network"
ss1=nrow(AD1)
ss2=nrow(AD2)
sxCors1 <- cor_auto(data1)
sxCors2 <- cor_auto(data2)

thiscol="spring"
thisgraph="glasso"
legendsz=0.3
thistune=0.5
thismax=1
thismin=0
thisesz=5
thisvsz=5


# Graphs
par(mfrow=c(1,2))
Graph1 <- qgraph(sxCors1, layout = thiscol, graph = thisgraph, sampleSize = ss1,
      groups = thesegroups, legend.cex = legendsz, title = title1,
        tuning = thistune, maximum = thismax, minimum = thismin, esize = thisesz,
      vsize = thisvsz)

Graph2 <- qgraph(sxCors2, layout = thiscol, graph = thisgraph, sampleSize = ss2,
      groups = thesegroups, legend.cex = legendsz, title = title2,
        tuning = thistune, maximum = thismax, minimum = thismin, esize = thisesz,
      vsize = thisvsz)

	
	
	}