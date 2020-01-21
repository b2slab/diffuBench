# load("~/all/devel/projects/bioinfo/003_diffusion_graphs/code/ranks/data/all.oldnew.RData")
# mat.network <- (data.oldnew$network)
# mat.old <- data.oldnew$train
# mat.new <- data.oldnew$test

library(igraph)
library(plyr)

# these params are needed!
source("params.R")

computeAllPartitions <- function(
  g.network, 
  mat.old, 
  mat.new
) {
  set.seed(1)
  
  list.paths <- colnames(mat.old)
  list.genes <- rownames(mat.old)
  n.paths <- length(list.paths)
  n.genes <- length(list.genes)
  
  # Check the network
  stopifnot(is.directed(g.network))
  stopifnot(is.connected(g.network))
  stopifnot(is.simple(g.network))
  
  message("Computing centralities...")
  list.g <- list(
    Degree = degree(g.network), 
    # Closeness = closeness(g.network), 
    PageRank = page.rank(g.network)$vector
  )
  
  # lists to partition pathways
  list.oldsize <- colSums(mat.old)
  list.newsize <- colSums(mat.new)
  list.change <- list.newsize/list.oldsize
  list.overlap <- sapply(
    list.paths, 
    function(ind) 
      sum(mat.old[, ind]*mat.new[, ind])/min(sum(mat.old[, ind]), 
                                             sum(mat.new[, ind]))
  )
  list.degreefdr <- sapply(
    list.paths, 
    function(path) {
      wilcox.test(
        x = list.g$Degree, 
        y = list.g$Degree[which(mat.new[, path] == 1)], 
        alternative = "less"
      )$p.value
    }
  ) %>% p.adjust
  
  partition.paths <- list(
    Size = list(
      small = which(list.oldsize <= size_small), 
      large = which(list.oldsize > size_small)
    ), 
    Growth = list(
      no_increase = which(list.change <= growth_increase), 
      increase = which(list.change > growth_increase)
    ), 
    Overlap = list(
      small = which(list.overlap <= overlap_small), 
      medium = which(list.overlap > overlap_small & 
                       list.overlap <= overlap_high), 
      high = which(list.overlap > overlap_high)
    ), 
    TopologyBias = list(
      not_proven = which(list.degreefdr >= topobias_fdr), 
      proven = which(list.degreefdr < topobias_fdr)
    )
  )
  
  partition.genes <- list(
    All = setNames(
      plyr::llply(
        list.paths, 
        function(path) {
          setNames(
            1:n.genes, 
            list.genes)
        }),
      list.paths
    ), 
    InPathway = setNames(
      plyr::llply(
        list.paths, 
        function(path) {
          which(mat.old[, path])
        }),
      list.paths
    ), 
    OutsidePathway = setNames(
      plyr::llply(
        list.paths, 
        function(path) {
          which(!mat.old[, path])
        }),
      list.paths
    ), 
    LowDegree = setNames(
      plyr::llply(
        list.paths, 
        function(path) {
          which(list.g$Degree <= degree_low)
        }),
      list.paths
    ), 
    HighDegree = setNames(
      plyr::llply(
        list.paths, 
        function(path) {
          which(list.g$Degree > degree_high)
        }),
      list.paths
    )
  )
  
  ans <- list(
    genes = partition.genes, 
    paths = partition.paths
  )
  
  ans
}