library(R.matlab)
library(tcor)
library(threejs)
library(igraph)
library(foreach)
library(doMC)

registerDoMC()

m = readMat("TRT001_1_S001_2_3_for_testing.mat")
saveRDS(m, "m.rds")
#m = readRDS("m.rds")

mat = m$data
rm(m)
gc()
rownames(mat) = 1:nrow(mat)
colnames(mat) = 1:ncol(mat)

zero_row = apply(mat, 1, function(x) all(as.integer(x) == 0))

ms = t(mat[!zero_row,])
rm(mat)

#saveRDS(zero_row, "zero_row.rds")

gc()

saveRDS(ms, "ms.rds")
#ms = readRDS("ms.rds")

#tc = readRDS(tc, "tc.rds")
tc0 = tcor(ms, t=0.999, include_anti=TRUE, dry_run=TRUE)
saveRDS(tc0, "tc0.rds")
system.time({
  tc = tcor(ms, t=0.999, include_anti=TRUE, restart=tc0)
})
saveRDS(tc, "tc.rds")

g = from_edge_list(tc$indices[,-3])
saveRDS(g, "g.rds")

graphjs(g)
