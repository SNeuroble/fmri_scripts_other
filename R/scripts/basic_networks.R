#simple adjacencymat

install.packages('qgraph')
require('qgraph')

A=matrix(rnorm(100),nrow=10,ncol=10)
# randnum: rnorm(nentries,mean,sd)

adj_mat=cor(A,A)

# g1 <- graph.adjacency(adj_mat)
# plot.igraph(g1)

# Q <- qgraph(adj_mat, minimum = 0.25, cut = 0.4, vsize = 1.5, borders = FALSE)
# Q <- qgraph(Q, layout = "spring")
# qgraph(Q, posCol = "red", negCol = "blue")
qgraph(adj_mat, graph = "sig", layout = "circular")

par(mfrow=c(1,2))
hist(adj_mat)
image(adj_mat)

title("My graph", line = 2.5)





# preset example
# Load big5 dataset:
# data(big5)
# data(big5groups)

# # Correlations:
# Q <- qgraph(cor(big5), minimum = 0.25, cut = 0.4, vsize = 1.5, groups = big5groups, 
    # legend = TRUE, borders = FALSE)
    
    # qgraph(Q, graph = "sig2")
# title("Big 5 correlations (p-values)", line = 2.5)
    
# title("Big 5 correlations", line = 2.5)