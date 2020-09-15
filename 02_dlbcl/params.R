# parameters

### folders
dir_metadata <- "00_metadata"
dir_venn <- "01_venn"
dir_kegg <- "01_kegg"
dir_graph <- "01_network"
file_graph <- paste0(dir_graph, "/interactome_curated.RData")
dir_simul <- "03_simulated_data"
dir_scores <- "04_diffusion_scores"
dir_stats <- "04_statistics"
dir_models <- "04_models"
dir_plots <- "05_plots"
dir_positive <- "06_positive_analysis"
dir_main <- "10_main"

### main analysis
file_kernel <- "~/big/devel/big/diffusion/kernell_dlbcl.RData"
# changed single fdr to two possibilities
# threshold_fdr <- .1
list_fdr <- c(.1, .05)
n.perm <- 1000
# methods to screen
list_methods <- c("raw", "ml", "gm", "ber_s", "ber_p", "mc", "z")
# arrays to screen
# can be found in the vertex attributes of g_cc
list_arrays <- c(Lym = "obs_lym", ALL = "obs_all")
star.cutoffs <- c(.05, .01, .001)

# stratifications to compute the auc
list_strat <- c(obs = "id_obs", hid = "id_hid", all = "id_all")
list_strat_plot <- c("id_obs" = "Labelled", "id_hid" = "Unlabelled", "id_all" = "Overall")

### signal generation
# minimum number of genes in a pathway
N_min <- 30
# number of signals to generate
n_trials <- 50
# proportion of affected genes
r <- c(.3, .5, .7)
# number of pathways
k <- c(1, 3, 5, 10)
# maximum p-value
pmax <- c(1e-2, 1e-3, 1e-4, 1e-5)

# # debug only - minimal amount of simulations
# # number of signals to generate
# n_trials <- 2
# # proportion of affected genes
# r <- c(.3, .5)
# # number of pathways
# k <- c(1, 3)
# # maximum p-value
# pmax <- c(1e-3, 1e-4) 
