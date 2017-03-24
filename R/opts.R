#' Add legend
#'
#' @param p a datamaps object
#'
#' @examples
#' data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     values = c("N. America", "EU", "Asia", "EU", "Africa", "Africa"))
#'
#' data %>%
#'     datamaps() %>%
#'     add_choropleth(name, values, colors = c("skyblue", "yellow", "orangered")) %>%
#'     add_legend()
#'
#' @export
add_legend <- function(p){
  p$x$legend <- TRUE
  p
}

#' Add labels
#'
#' @param p a datamaps object
#'
#' @examples
#' states <- data.frame(st = c("AR", "NY", "CA", "IL"),
#'     val = c(10, 5, 3, 8))
#'
#' states %>%
#'     datamaps("usa") %>%
#'     add_choropleth(st, val) %>%
#'     add_labels()
#'
#' @export
add_labels <- function(p){
  p$x$labels <- TRUE
  p
}
