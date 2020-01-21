# parameters

### folders
dir_metadata <- "00_metadata"
dir_main <- "10_main"

### plots
# for stargazer, use the same star cutoffs as base R
star.cutoffs <- c(.05, .01, .001)

### main analysis
n.perm <- 10000
# methods to screen
list_methods <- c("raw", "ml", "gm", "ber_s", "ber_p", "mc", "z")
