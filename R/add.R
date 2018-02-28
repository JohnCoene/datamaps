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
#' cat <- data.frame(name = c("USA", "BRA", "COL", "CAN", "ARG", "CHL"),
#'     col = rep(c("Yes", "No"), 6))
#'
#' cat %>%
#'     datamaps(projection = "orthographic") %>%
#'     add_choropleth(name, col, colors = c("red", "blue"))
#'
#' # US states
#' states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
#'     val = c(10, 5, 3, 8, 6, 7, 2))
#'
#' states %>%
#'     datamaps(scope = "usa", default = "lightgray") %>%
#'     add_choropleth(st, val) %>%
#'     add_labels()
#'
#' @export
add_choropleth <- function(p, locations, color, ..., colors = c("#FFEDA0", "#FEB24C", "#F03B20")){

  data <- get("data", envir = data_env)
  loc <- eval(substitute(locations), data)
  col <- eval(substitute(color), data)

  p$x$fills <- append(p$x$fills, fill_data_(col, colors))

  p$x$data <- append(p$x$data, choro_data_(loc, col, ...))

  p

}

#' Add bubbles
#'
#' Add bubbles to the map.
#'
#' @param p a datamaps object.
#' @param longitude,latitude coordinates of bubbles.
#' @param radius radius of bubbles.
#' @param color color of bubbles.
#' @param colors color palette.
#' @param name name of bubbles.
#' @param ... any other variable to use in tooltip.
#'
#' @examples
#' coords <- data.frame(city = c("London", "New York", "Beijing", "Sydney"),
#'                      lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
#'                      lat = c(51.49999, 40.74998, 39.92889, -33.92001),
#'                      values = runif(4, 5, 17))
#'
#' coords %>%
#'     datamaps() %>%
#'     add_bubbles(lon, lat, values * 2, values, city)
#'
#' data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     color = round(runif(6, 1, 10)))
#'
#' data %>%
#'     datamaps(default = "lightgray") %>%
#'     add_choropleth(name, color) %>%
#'     add_data(coords) %>%
#'     add_bubbles(lon, lat, values * 2, values, city, colors = c("red", "blue"))
#'
#' @export
add_bubbles <- function(p, longitude, latitude, radius, color, name, ..., colors = c("#FFEDA0", "#FEB24C", "#F03B20")){

  data <- get("data", envir = data_env)
  col <- eval(substitute(color), data)
  lon <- eval(substitute(longitude), data)
  lat <- eval(substitute(latitude), data)
  rad <- eval(substitute(radius), data)
  nam <- eval(substitute(name), data)

  p$x$fills <- append(p$x$fills, fill_data_(col, colors))

  p$x$bubbles <- append(p$x$bubbles, bubbles_data_(lon, lat, rad, col, nam, ...))

  p

}

#' Add data
#'
#' Add a dataset.
#'
#' @param p a datamaps object.
#' @param data data.frame.
#'
#' @examples
#' coords <- data.frame(city = c("London", "New York", "Beijing", "Sydney"),
#'                      lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
#'                      lat = c(51.49999, 40.74998, 39.92889, -33.92001),
#'                      values = c(11, 23, 29 , 42))
#'
#' data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA",
#'                             "BRA", "AFG"),
#'     color = round(runif(8, 1, 10)))
#'
#' edges <- data.frame(origin = c("USA", "FRA", "BGD", "ETH", "KHM", "GRD",
#'                                "FJI", "GNB", "AUT", "YEM"),
#'     target = c("BRA", "USA", "URY", "ZAF", "SAU", "SVK", "RWA", "SWE",
#'                "TUV", "ZWE"),
#'     strokeColor = rep(c("gray", "black"), 5))
#'
#' data %>%
#'     datamaps(default = "lightgray") %>%
#'     add_choropleth(name, color) %>%
#'     add_data(coords) %>%
#'     add_bubbles(lon, lat, values, values, city, colors = c("skyblue", "darkblue")) %>%
#'     add_data(edges) %>%
#'     add_arcs_name(origin, target, strokeColor)
#'
#' @export
add_data <- function(p, data) {

  if(!missing(data))
    assign("data", data, envir = data_env)
  else
    stop("missing data", call. = FALSE)

  p
}


#' Add arcs
#'
#' Add arcs by name of country of state.
#'
#' @param p a datamaps object.
#' @param origin,destination edges.
#' @param ... any other arguments to use as options.
#'
#' @examples
#' data <- data.frame(origin = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     target = c("FRA", "RUS", "BEL", "CAF", "VEN", "SWZ"),
#'     greatArc = rep(c(TRUE, FALSE), 3),
#'     arcSharpness = 2)
#'
#' data %>%
#'     datamaps() %>%
#'     add_arcs_name(origin, target, greatArc, arcSharpness)
#'
#' # US states
#' states <- data.frame(origin = c("AR", "NY", "CA", "IL", "CO", "MT",
#'                                 "TX", "WA", "TN", "MT"),
#'     target = c("OR", "SD", "WI", "TX", "LA", "AZ", "FL", "MI", "HI",
#'                "OK"),
#'     strokeWidth = runif(10, 1, 9),
#'     strokeColor = colorRampPalette(c("red", "blue"))(10))
#'
#' states %>%
#'     datamaps(scope = "USA", default = "lightgray") %>%
#'     add_arcs_name(origin, target, strokeWidth, strokeColor)
#'
#' @export
add_arcs_name <- function(p, origin, destination, ...){

  data <- get("data", envir = data_env)
  ori <- eval(substitute(origin), data)
  des <- eval(substitute(destination), data)

  p$x$arcs <- append(p$x$arcs, arc_data_(ori, des, ...))

  p
}

#' Add arcs
#'
#' Add arcs by coordinates.
#'
#' @param p a datamaps object.
#' @param origin.lon,origin.lat origin coordinates.
#' @param destination.lon,destination.lat destination coordinates.
#' @param ... any other arguments to use as options.
#'
#' @examples
#' states <- data.frame(ori.lon = c(-97.03720, -87.90446),
#'     ori.lat = c(32.89595, 41.97960),
#'     des.lon = c(-106.60919, -97.66987),
#'     des.lat = c(35.04022, 30.19453),
#'     strokeColor = c("blue", "red"),
#'     arcSharpness = c(2, 1))
#'
#' states %>%
#'     datamaps(scope = "USA", default = "lightgray") %>%
#'     add_arcs(ori.lon, ori.lat, des.lon, des.lat, strokeColor)
#'
#' @export
add_arcs <- function(p, origin.lon, origin.lat, destination.lon, destination.lat, ...){

  data <- get("data", envir = data_env)
  ori.lon <- eval(substitute(origin.lon), data)
  ori.lat <- eval(substitute(origin.lat), data)
  des.lon <- eval(substitute(destination.lon), data)
  des.lat <- eval(substitute(destination.lat), data)

  p$x$arcs <- append(p$x$arcs, arc_data__(ori.lon, ori.lat, des.lon, des.lat, ...))

  p
}
