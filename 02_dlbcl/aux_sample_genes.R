# list_path: list with kegg pathways
# bkgd: vector with background genes
# pmax: maximum p-value for alternative hypothesis
# r: fraction of genes affected in pathway
# k: number of pathways
# n_trials: number of artificial inputs to create
# 
# returns list with:
# truth: a list with the differentially expressed genes and the whole pathways
# mat_input: matrix of artificial p-values. 
#  Each random dataset is a column, each row is a gene
# mat_validation: matrix of target genes (all within the 
#  sampled pathways). Each row is a gene: 0 if not in the pathway, 
#  1 otherwise
# params: list of the params k, r, pmax
library(magrittr)
sample_genes <- function(list_path, bkgd, pmax, r, k, n_trials) {
  
  # browser()
  
  # generate ground truth
  truth <- lapply(
    integer(n_trials), 
    function(dummy){
      # sample k pathways 
      paths <- sample(list_path, k)
      # sample a proportion of r genes in each
      genes_de <- lapply(
        paths, 
        function(path) {
          sample(as.character(path), size = r*length(path))
        }
      ) #%>% unlist %>% unique
      # genes_truth <- unique(unlist(paths))
      
      list(genes_de = genes_de, genes_truth = paths)
      # genes_de
    }
  )
  
  # generate p-values
  mat_input <- sapply(
    truth, 
    function(trial) {
      # uniform p-values
      ans <- setNames(
        runif(n = length(bkgd)), 
        bkgd
      )
      # modify p-values from input to cap at pmax
      input <- as.character(unlist(unique(trial$genes_de)))
      ans[input] <- runif(n = length(input), min = 0, max = pmax)
      
      ans
    }
  ) %>% set_colnames(paste0("run", 1:n_trials))
  
  mat_validation <- sapply(
    truth, 
    function(trial) {
      ans <- setNames(
        integer(length = length(bkgd)), 
        bkgd
      )
      # modify values from ground truth
      ground <- as.character(unlist(unique(trial$genes_truth)))
      ans[ground] <- 1L
      
      ans
    }
  ) %>% set_colnames(paste0("run", 1:n_trials))
  
  list(truth = truth, mat_input = mat_input, 
       mat_validation = mat_validation, 
       params = list(k = k, r = r, pmax = pmax))
}