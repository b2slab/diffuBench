#' Generate a random input for graph diffusion
#'
#' This function assumes that the unnormalised scores are non negative!
#' It returns the inputs \code{mat_input} and the targets \code{mat_target}, 
#' i.e. the ground truth. 
#' This was used as a simulated case study in the yeast dataset.
#' 
#' @param graph an \pkg{igraph} object
#' @param K kernel matrix for graph \code{graph}
#' @param reps integer, number of cases to generate
#' @param prop_target,prop_input proportion of nodes that will be positive 
#' in the target and in the input
#' @param sampling_bias logical, should signals be biased (like \code{raw}) 
#' or unbiased (like \method{mc})?
#' @param seed integer, seed for random number generator
#' @param n.perm integer, number of permutations 
#' for generating unbiased signals
#'
#' @return A list of two matrices: \code{mat_input} (input nodes in rows, 
#' case id in columns) and the ground truth in 
#' \code{mat_target} (target nodes in rows, case id in columns).
#'
#' @examples
#' g <- generate_graph(
#'     fun_gen = igraph::barabasi.game,
#'     param_gen = list(n = 200, m = 3, directed = FALSE),
#'     seed = 1)
#' synth_input <- generate_input(
#'     g,
#'     K = regularisedLaplacianKernel(g), 
#'     reps = 20, 
#'     prop_target = .1, 
#'     prop_input = .1, 
#'     sampling_bias = FALSE)
#' str(synth_input)
#'
#' @importFrom plyr llply
#' @import igraph magrittr
#' @export
generate_input <- function(
  graph, 
  K, 
  reps,
  prop_target, 
  prop_input, 
  sampling_bias = FALSE, 
  seed = NULL, 
  n.perm = 1000) {
  # browser()
  
  # column labels
  if (sampling_bias) {
    str_start <- "Biased"
    met_diff <- "raw"
  } else {
    str_start <- "Unbiased"
    met_diff <- "mc"
  }
  
  if (!is.null(seed)) set.seed(seed)
  
  # possible solutions
  id.target <- V(graph)[class == "target"]$name
  id.labelled <- V(graph)[class == "labelled"]$name
  # number of nodes to sample
  n_target <- length(id.target)*prop_target
  n_input <- length(id.labelled)*prop_input
  
  names.col <- paste0(str_start, seq_len(reps))
  
  # Sample the labelled nodes uniformly
  mat_input <- replicate(reps, (id.labelled %in% sample(id.labelled, n_input))*1L) %>% 
    set_rownames(id.labelled) %>% 
    set_colnames(names.col)
  
  # diffusion scores of target nodes
  f.diff <- diffuse(
    K = K, scores = mat_input, method = met_diff, n.perm = n.perm
  )[id.target, , drop = FALSE]
  if (!sampling_bias) f.diff <- f.diff + 1/(n.perm + 1)
  
  mat_target <- apply(
    f.diff, 2, function(col) {
      # sampling with probability proportional to diffusion scores
      vec.pos <- sample(id.target, size = n_target, prob = col)
      setNames((id.target %in% vec.pos)*1L, id.target)
    }
  )
  
  list(mat_input = mat_input, mat_target = mat_target)
}
