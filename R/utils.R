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

arc_data__ <- function(ori.lon, ori.lat, des.lon, des.lat, ...){

  # process additional arguments
  data <- get("data", envir = data_env) # get data for eval
  dots <- eval(substitute(alist(...))) # capture dots
  base <- lapply(dots, eval, data) # eval
  names(base) <- sapply(dots, deparse) # deparse for name
  base <- as.data.frame(base) # to data.frame

  # edges
  edges <- list()
  for(i in 1:length(ori.lon)){
    edges[[i]] <- list(origin = list(latitude = ori.lat[i], longitude = ori.lon[i]),
                      destination = list(latitude = des.lat[i], longitude = des.lon[i]))
  }

  if(nrow(base) == length(edges)){

    # catch 1 col
    if(ncol(base) == 1) base$singleCol <- TRUE

    for(i in 1:length(edges)){
      bs <- apply(base[i,], 1, as.list)
      names(bs) <- "options"
      edges[[i]] <- append(edges[[i]], bs)
    }
  }

  return(edges)

}
