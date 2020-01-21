describe_net <- function(g) {
  # g <- barabasi.game(1000, power = 1, m = 3)
  # g
  deg <- igraph::degree(g, mode = "all")
  plf <- igraph::fit_power_law(x = deg + 1, xmin = 5)
  data.frame(
    vcount = igraph::vcount(g), 
    ecount = igraph::ecount(g), 
    density = igraph::graph.density(g), 
    alpha = plf$alpha
  )
}

# common color palette
colour_npg <- setNames(
  c(ggsci::pal_npg()(10)[c(1:7, 9:10)], "gray25"), 
  c("raw", "ml", "gm", "ber_s", "ber_p", "mc", "z", "pagerank", "random", "original")
)
# scales::show_col(colour_npg)

# supplement 1 and 2
colour_jama <- setNames(
  ggsci::pal_jama()(2), 
  c("Negative", "Positive")
)

# supplement 3
colour_simpson <- setNames(
  ggsci::pal_simpsons()(2), 
  c("TRUE", "FALSE")
)

colour_pathwaysize <- setNames(
  ggsci::pal_lancet()(8)[c(5, 8)],
  c(">5", "<=5")
)

# axis text
ebias_text <- expression(paste(
  b[mu]^kappa, 
  plain(" (proportional to expected value)")))
ebias_text_short <- expression(paste(b[mu]^kappa))

vbias_text <- expression(paste(
  b[sigma^2]^kappa, 
  plain(" (proportional to log of variance)")))
vbias_text_short <- expression(paste(b[sigma^2]^kappa))
vbias_text_fdr <- expression(paste(
  plain("FDR for differences in "), b[sigma^2]^kappa))
vbias_text_median_pathway <- expression(paste(
  plain("Median value of "), b[sigma^2]^kappa, 
  plain(" (per pathway and node type)")
))
vbias_text_new_vs_other <- expression(
    median*group("{",list(b[sigma^2]^kappa*(i), i %in% new),"}") - median*group("{",list(b[sigma^2]^kappa*(i), i %in% other),"}")
)
vbias_text_pathway <- expression(paste(
  plain("Pathway reference variance "), bp[sigma^2]^kappa
))


# K: kernel sub-matrix (not necessarily square)
# mu_y: mean of input vector y
get_mu <- function(K, mu_y) {
  mu_y*rowSums(K)
}

# K: kernel sub-matrix (not necessarily square)
# var_y: variance of input vector y
# 
# changed denom to n-1 because it's simpler
get_covar <- function(K, var_y) {
  # n <- ncol(K)
  Kn <- K - rowMeans(K)
  
  # (var_y*n/(n - 1))*tcrossprod(Kn)
  var_y*tcrossprod(Kn)
}

# K: kernel sub-matrix (not necessarily square)
get_ebias <- function(K) {
  get_mu(K, mu_y = 1)
}

# K: kernel sub-matrix (not necessarily square)
# this one is slow but illustrative
get_vbias_ <- function(K) {
  log10(diag(get_covar(K, var_y = 1)))
}
# faster
get_vbias <- function(K) {
  n <- ncol(K)
  # apply(K, 1, var) = KK^T/(nl - 1)
  # bias = log10(nl/(nl - 1)*KK^T)
  log10(apply(K, 1, var)*(n - 1))
}
# equivalent formulation
get_vbias2 <- function(K) {
  n <- ncol(K)
  # bias(i) = sum_j ((k_ij - mean(k_i*))**2)
  log10(rowSums((K - get_ebias(K)/n)**2))
}

# check that all the ways of computing the variance bias are equivalent
local({
  g <- igraph::barabasi.game(500, directed = FALSE)
  K <- diffuStats::regularisedLaplacianKernel(g)
  
  v1 <- get_vbias(K[, 1:100])
  v2 <- get_vbias_(K[, 1:100])
  v3 <- get_vbias2(K[, 1:100])
  
  stopifnot(all(
    assertthat::are_equal(v1, v2), 
    assertthat::are_equal(v1, v3)
  ))
})
