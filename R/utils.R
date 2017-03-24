# filler
fill_data_ <- function(val, col, def){

  un_val <- as.character(unique(val))
  colors <- colorRampPalette(col)(length(un_val))
  table_col <- data.frame(colors = colors, values = un_val)
  assign("colors", table_col, envir = data_env)

  # default
  colors <- c(colors, def)
  id <- c(un_val, "defaultFill")

  data <- sapply(colors, as.list)
  names(data) <- id

  return(data)
}

choro_data_ <- function(loc, val){

  data <- data.frame(fillKey = val, values = val)
  data <- apply(data, 1, as.list)
  names(data) <- as.character(loc)

  return(data)
}

get_id_ <- function(v){
  1:length(v)
}
