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
  val_char <- as.character(val)
  if(nrow(base))
    base$fillKey <- val_char
  else
    base <- data.frame(fillKey = val_char)

  base <- apply(base, 1, as.list)
  names(base) <- as.character(loc)

  return(base)
}

bubbles_data_ <- function(lon, lat, rad, col, nam, ...){

  # process additional arguments
  data <- get("data", envir = data_env) # get data for eval
  dots <- eval(substitute(alist(...))) # capture dots
  base <- lapply(dots, eval, data) # eval
  names(base) <- sapply(dots, deparse) # deparse for name
  base <- as.data.frame(base) # to data.frame

  # add fillKey
  col_char <- as.character(col)
  if(nrow(base) > 1)
    base$fillKey <- col_char
  else
    base <- data.frame(fillKey = col_char)

  base$longitude <- lon
  base$latitude <- lat
  base$radius <- rad
  base$name <- nam

  base <- apply(base, 1, as.list)

  return(base)
}

arc_data_ <- function(ori, des, ...){

  # process additional arguments
  data <- get("data", envir = data_env) # get data for eval
  dots <- eval(substitute(alist(...))) # capture dots
  base <- lapply(dots, eval, data) # eval
  names(base) <- sapply(dots, deparse) # deparse for name
  base <- as.data.frame(base) # to data.frame

  if(nrow(base) > 1){
    base$origin <- ori
    base$destination <- des
  } else {
    base <- data.frame(origin = ori, destination = des)
  }

  apply(base, 1, as.list)

}
