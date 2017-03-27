# filler
fill_data_ <- function(val, col){

  un_val <- as.character(unique(val))
  colors <- colorRampPalette(col)(length(un_val))
  table_col <- data.frame(colors = colors, values = un_val)
  assign("colors", table_col, envir = data_env)

  # default
  data <- sapply(colors, as.list)
  names(data) <- un_val

  return(data)
}

choro_data_ <- function(loc, val, ...){

  # process additional arguments
  data <- get("data", envir = data_env) # get data for eval
  dots <- eval(substitute(alist(...))) # capture dots
  base <- lapply(dots, eval, data) # eval
  names(base) <- sapply(dots, deparse) # deparse for name
  base <- as.data.frame(base) # to data.frame

  # add fillKey
  if(nrow(base))
    base$fillKey <- val
  else
    base <- data.frame(fillKey = val)

  base <- apply(base, 1, as.list)
  names(base) <- as.character(loc)

  return(base)
}

get_id_ <- function(v){
  1:length(v)
}
