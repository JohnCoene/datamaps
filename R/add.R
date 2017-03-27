#' Add choropleth
#'
#' Add choropleth data.
#'
#' @param p a datamaps object.
#' @param locations column containing location names as \code{iso3c}.
#' @param color column containing color of each \code{location}.
#' @param ... any other variable to use for tooltip.
#' @param colors color palette.
#'
#' @examples
#' data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     color = round(runif(6, 1, 10)))
#'
#' data %>%
#'     datamaps() %>%
#'     add_choropleth(name, color, colors = c("skyblue", "yellow", "orangered"))
#'
#' # categorical colors
#' cat <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     col = rep(c("Yes", "No"), 6))
#'
#' cat %>%
#'     datamaps() %>%
#'     add_choropleth(name, col, colors = c("red", "blue"))
#'
#' # US states
#' states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
#'     val = c(10, 5, 3, 8, 6, 7, 2))
#'
#' states %>%
#'     datamaps("usa", "lightgray") %>%
#'     add_choropleth(st, val) %>%
#'     add_labels()
#'
#' @export
add_choropleth <- function(p, locations, color, ..., colors = c("#FFEDA0", "#FEB24C", "#F03B20")){

  data <- get("data", envir = data_env)
  loc <- eval(substitute(locations), data)
  col <- eval(substitute(color), data)

  p$x$fills <- append(p$x$fills, fill_data_(col, colors))

  p$x$data <- choro_data_(loc, col, ...)

  p

}

#' Add bubbles
#'
#' @param p a datamaps object.
#'
#' @export
add_bubbles <- function(p){

}
