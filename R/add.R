#' Add choropleth
#'
#' Add choropleth data.
#'
#' @export
add_choropleth <- function(p, locations, values, colors = c("blue", "white", "red"), default = "gray"){

  data <- get("data", envir = data_env)
  loc <- eval(substitute(locations), data)
  val <- eval(substitute(values), data)

  p$x$fills <- fill_data_(val, colors)

  p$x$data <- choro_data_(loc, val)

  p

}
