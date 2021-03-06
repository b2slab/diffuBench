---
title: "Diffusion scores"
author: "Sergio Picart-Armada"
date: "September 14, 2017"
output: html_document
---


```r
library(igraph)
library(plyr)
library(magrittr)
library(diffuStats)

library(tictoc)

source("params.R")

# The kernel is heavy (1GB) and takes some time to load
load(file_kernel)

# the training data is mat.old
vars <- load(file_dataset)
stopifnot("mat.old" %in% vars)
```

# Compute the scores


```r
set.seed(1)

# pagerank
pr <- igraph::page.rank(g.network)$vector

# sweep bkgds: is every gene labelled? (positive inside pathway, 
# negative outside it) or is the union of all pathways considered 
# as the labelled genes, and the rest are unlabelled?
id_bkgd <- list(
  pathways = which(rowSums(mat.old) > 0),
  all = setNames(1:nrow(mat.old), rownames(mat.old)))

tic("Scoring algorithms")
plyr::l_ply(
  list_bkgd, 
  function(bkgd) {
    # pick the labelled genes as a function of the background
    input <- mat.old[id_bkgd[[bkgd]], ]*1
    # compute the scores
    list_diff <- lapply(
      list_methods, 
      function(method) {
        diffuStats::diffuse(
          K = K, 
          scores = input, 
          method = method, 
          n.perm = n.perm
        )
      }
    ) %>% set_names(list_methods)
    
    # Baseline: pagerank centralities
    list_diff$pagerank <- replicate(n = ncol(input), 
                                    expr = pr[rownames(K)]) %>%
      set_colnames(colnames(input))
        
    # dummy random scores
    set.seed(2)
    list_diff$random <- replicate(n = ncol(input), expr = sample(length(pr))) 
    dimnames(list_diff$random) <- dimnames(list_diff$pagerank) 
    
    # save with maximum compression
    save(list_diff, file = paste0(dir_scores, "/", bkgd, ".RData"), 
         compress = "xz")
  }
)
```


```r
# elapsed time
toc()
```

```
## Scoring algorithms: 3935.231 sec elapsed
```


# Reproducibility


```r
out <- capture.output(sessionInfo())
writeLines(out, con = paste0(dir_metadata, "/02_sessionInfo.txt"))
```

