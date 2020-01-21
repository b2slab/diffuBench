# This function returns only the deepest dirs in a 
# character vector, by counting the slashes
deepest_dirs <- function(dirs) {
  counts <- stringr::str_count(pattern = "/", string = dirs)
  dirs[counts == max(counts)]
}