#' Add choropleth
#'
#' Add choropleth data.
#'
#' @param p a datamaps object.
#' @param locations column containing location names as \code{iso3c}.
#' @param values column containing values of each \code{location}.
#' @param colors color palette.
#' @param default default color for missing locations.
#'
#' @examples
#' data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     values = round(runif(6, 1, 10)))
#'
#' data %>%
#'     datamaps() %>%
#'     add_choropleth(name, values, colors = c("skyblue", "yellow", "orangered"))
#'
#' states <- data.frame(st = c("AR", "NY", "CA", "IL"),
#'     val = c(10, 5, 3, 8))
#'
#' states %>%
#'     datamaps("usa") %>%
#'     add_choropleth(st, val)
#'
#' @export
add_choropleth <- function(p, locations, values, colors = c("blue", "white", "red"), default = "gray"){

  data <- get("data", envir = data_env)
  loc <- eval(substitute(locations), data)
  val <- eval(substitute(values), data)

  p$x$fills <- fill_data_(val, colors, default)

  p$x$data <- choro_data_(loc, val)

  p

}
