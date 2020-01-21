# translates a named vector or list of parameters to a character
# e.g. c(a=1,b=2) -> a_1-b_2
param2name <- function(v) {
  p <- paste(names(v), unlist(v), sep = "_")
  paste(p, collapse = ",")
}

# the inverse: returns a named parameter vector from a pasted character
# it strips the .RData if present
name2param <- function(name, numeric = FALSE) {
  name <- gsub("(.+)(\\.RData$)", "\\1", name)
  z <- strsplit(name, split = ",")[[1]]
  zs <- strsplit(z, split = "_")
  
  object <- sapply(zs, function(x) x[2])
  if (numeric) object <- as.numeric(object)
  nm <- sapply(zs, function(x) x[1])
  
  setNames(object, nm)
}
