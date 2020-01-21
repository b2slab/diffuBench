# parameters

### folders
dir_metadata <- "00_metadata"
dir_data <- "01_data"
file_dataset <- paste0(dir_data, "/dataset.RData")
file_partitions <- paste0(dir_data, "/partitions.RData")
dir_descriptive <- "01_descriptive"
dir_scores <- "02_diffusion_scores"
dir_stats <- "03_statistics"
dir_plots <- "04_plots"
dir_main <- "10_main"

### main analysis
file_kernel <- "~/big/devel/big/diffusion/kernel_laplacian_retrodata.RData"
n.perm <- 10000
# methods to screen
list_methods <- c("raw", "ml", "gm", "ber_s", "ber_p", "mc", "z")
list_bkgd <- c(pathways = "pathways", all = "all")

### signal filtering
# minimum number of genes in a pathway
N_min <- 5
# network partition
size_small <- 30
growth_increase <- 1
jaccard_high <- 0.9
topobias_fdr <- 0.1
degree_low <- 3
degree_high <- 30
# names of the partitions
partition_names <- c("None", "Large", "Growth", 
                     "SimilarJaccard", "TopologyBias", "Biased")
# minimum size of the pathway growth (i.e. minimum 
# positives to compute auc)
filter_pathways <- c(0, 3)