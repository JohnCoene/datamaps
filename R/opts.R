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
