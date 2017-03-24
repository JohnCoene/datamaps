# filler
fill_data_ <- function(val, col, def){

  colors <- colorRampPalette(col)(length(val))
  id <- get_id_(val)

  # default
  colors <- c(colors, def)
  id <- c(id, "defaultFill")

  data <- sapply(colors, as.list)
  names(data) <- id

  return(data)
}

choro_data_ <- function(loc, val){
  id <- get_id_(val)

  data <- data.frame(fillKey = id, values = val)
  data <- apply(data, 1, as.list)
  names(data) <- as.character(loc)

  return(data)
}

get_id_ <- function(v){
  1:length(v)
}
