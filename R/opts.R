#' Add legend
#'
#' Add a legend to the map.
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
#' Add data labels.
#'
#' @param p a datamaps object.
#' @param label.color label color.
#' @param line.width width of line.
#' @param font.size font size.
#' @param font.family font family.
#' @param ... any other parameter.
#'
#' @examples
#' states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
#'     val = c(10, 5, 3, 8, 6, 7, 2))
#'
#' states %>%
#'     datamaps("usa") %>%
#'     add_choropleth(st, val) %>%
#'     add_labels(label.color = "blue")
#'
#' @export
add_labels <- function(p, label.color = "#000", line.width = 1, font.size = 10, font.family = "Verdana", ...){

  opts <- list(...)
  opts$labelColor <- label.color
  opts$lineWidth <- line.width
  opts$fontSize <- font.size
  opts$fontFamily <- font.family

  p$x$labels$options <- opts
  p
}

#' Configure map
#'
#' Define options of the map.
#'
#' @param p a datamaps object.
#' @param popup.on.hover whether to show popover.
#' @param highlight.on.hover whether to enable popover.
#' @param hide.antarctica whether to hide Antarctica.
#' @param hide.hawaii.and.alaska whether to hide hide Hawaii and Alaska.
#' @param border.width country border width.
#' @param border.opacity Opacity of country borders.
#' @param border.color color of country borders.
#' @param highlight.border.width bubble's width on hover.
#' @param highlight.fill.color bubbles fill color on hover.
#' @param highlight.border.opacity bubbles opacity on hover.
#' @param highlight.border.color bubble's border opacity on hover.
#' @param highlight.fill.opacity bubble's opacity on hover.
#' @param data.url topo.json data url.
#' @param ... any other parameter.
#'
#' @examples
#' data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
#'     values = c("N. America", "EU", "Asia", "EU", "Africa", "Africa"),
#'     letters = LETTERS[1:6])
#'
#' data %>%
#'     datamaps(default = "lightgray") %>%
#'     add_choropleth(name, values) %>%
#'     config_geo(hide.antarctica = FALSE,
#'                border.width = 2,
#'                border.opacity = 0.6,
#'                border.color = "gray",
#'                highlight.border.color = "green",
#'                highlight.fill.color = "lightgreen")
#'
#' @export
config_geo <- function(p, popup.on.hover = TRUE, highlight.on.hover = TRUE, hide.antarctica = TRUE, hide.hawaii.and.alaska = FALSE,
                       border.width = 1, border.opacity = 1, border.color = "#FDFDFD", highlight.fill.color = "#FC8D59",
                       highlight.border.opacity = 1, highlight.border.color = "rgba(250, 15, 160, 0.2)",
                       highlight.fill.opacity = 0.85, highlight.border.width = 2, data.url = NULL, ...){

  opts <- list(...)
  opts$hideAntarctica <- hide.antarctica
  opts$hideHawaiiAndAlaska <- hide.hawaii.and.alaska
  opts$borderWidth <- border.width
  opts$borderOpacity <- border.opacity
  opts$borderColor <- border.color
  opts$highlightFillColor <- highlight.fill.color
  opts$highlightBorderOpacity <- highlight.border.opacity
  opts$highlightBorderColor <- highlight.border.color
  opts$highlightFillOpacity <- highlight.fill.opacity
  opts$highlightBorderWidth <- highlight.border.width

  p$x$geographyConfig <- append(p$x$geographyConfig, opts)
  if(!is.null(data.url)) p$x$geographyConfig$dataUrl <- data.url

  p
}

#' Configure bubbles
#'
#' Define options of the bubbles.
#'
#' @param p a datamaps object.
#' @param popup.on.hover whether to show popover.
#' @param highlight.on.hover whether to enable popover.
#' @param fill.opacity opacity of bubbles.
#' @param animate Wether to animate bubbles.
#' @param border.width width of bubbles.
#' @param border.opacity opacity of bubbles' border.
#' @param border.color color of bubbles' border.
#' @param highlight.border.width bubble's width on hover.
#' @param highlight.fill.color bubbles fill color on hover.
#' @param highlight.border.opacity bubbles opacity on hover.
#' @param highlight.border.color bubble's border opacity on hover.
#' @param highlight.fill.opacity bubble's opacity on hover.
#' @param exit.delay highlight delay.
#' @param ... any other parameter.
#'
#' @examples
#' coords <- data.frame(city = c("London", "New York", "Beijing", "Sydney"),
#'                      lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
#'                      lat = c(51.49999, 40.74998, 39.92889, -33.92001),
#'                      values = runif(4, 3, 20))
#'
#' coords %>%
#'     datamaps(default = "lightgray") %>%
#'     add_bubbles(lon, lat, values * 2, values, city) %>%
#'     config_bubbles(highlight.border.color = "rgba(0, 0, 0, 0.2)",
#'                    fill.opacity = 0.6,
#'                    border.width = 0.7,
#'                    highlight.border.width = 5,
#'                    highlight.fill.color = "green")
#'
#' @export
config_bubbles <- function(p, popup.on.hover = TRUE, highlight.on.hover = TRUE, fill.opacity = 0.75, animate = TRUE, border.width = 1,
                           border.opacity = 1, border.color = "#FDFDFD", highlight.fill.color = "#FC8D59", highlight.border.opacity = 1,
                           highlight.border.color = "rgba(250, 15, 160, 0.2)", highlight.fill.opacity = 0.85, highlight.border.width = 2,
                           exit.delay = 100,...){

  opts <- list(...)
  opts$popupOnHover <- popup.on.hover
  opts$highlightOnHover <- highlight.on.hover
  opts$borderWidth <- border.width
  opts$borderOpacity <- border.opacity
  opts$borderColor <- border.color
  opts$fillOpacity <- fill.opacity
  opts$animate <- animate
  opts$highlightFillColor <- highlight.fill.color
  opts$highlightBorderOpacity <- highlight.border.opacity
  opts$highlightBorderColor <- highlight.border.color
  opts$highlightFillOpacity <- highlight.fill.opacity
  opts$highlightBorderWidth <- highlight.border.width
  opts$exitDelay <- exit.delay

  p$x$bubblesConfig <- append(p$x$bubblesConfig, opts)

  p
}

#' Configure arcs
#'
#' Define options of the arcs.
#'
#' @param p a datamaps object.
#' @param stroke.color arc colors.
#' @param stroke.width arc width.
#' @param arc.sharpness arc sharpness.
#' @param animation.speed arc draw speed in milliseconds.
#' @param popup.on.hover whether to show tooltip.
#' @param ... any additional options.
#'
#' @examples
#' edges <- data.frame(origin = c("USA", "FRA", "BGD", "ETH", "KHM",
#'                                "GRD", "FJI", "GNB", "AUT", "YEM"),
#'     target = c("BRA", "USA", "URY", "ZAF", "SAU", "SVK", "RWA", "SWE",
#'                "TUV", "ZWE"))
#'
#' edges %>%
#'     datamaps() %>%
#'     add_arcs_name(origin, target) %>%
#'     config_arcs(stroke.color = "blue", stroke.width = 2, arc.sharpness = 1.5,
#'                 animation.speed = 1000)
#'
#' @export
config_arcs <- function(p, stroke.color = '#DD1C77', stroke.width = 1, arc.sharpness = 1, animation.speed = 600, popup.on.hover = FALSE,
                        ...){

  opts <- list(...)
  opts$strokeColor <- stroke.color
  opts$strokeWidth <- stroke.width
  opts$arcSharpness <- arc.sharpness
  opts$animationSpeed <- animation.speed
  opts$popupOnHover <- popup.on.hover

  p$x$arcConfig <- append(p$x$arcConfig, opts)

  p
}

#' Add graticule
#'
#' Add graticule.
#'
#' @param p a datamaps object.
#'
#' @examples
#' datamaps(projection = "orthographic") %>%
#'   add_graticule()
#'
#' @export
add_graticule <- function(p){
  p$x$graticule <- TRUE
  p
}


#' Set projection
#' 
#' @param p a datamaps object.
#' @param fun a JavaScript function.
#' 
#' @note Does not work in RStudio viewer, open in browser.
#' 
#' @examples 
#' topo <- paste0("https://rawgit.com/Anujarya300/bubble_maps/",
#'   "master/data/geography-data/india.topo.json")
#'   
#' data <- data.frame(state = c("JH", "MH"), value = c(55, 28))
#'   
#' data %>% 
#'   datamaps(scope = "india") %>% 
#'   add_choropleth(state, value) %>% 
#'   config_geo(data.url = topo) %>% 
#'   set_projection(htmlwidgets::JS('
#'   function (element) {
#'     var projection = d3.geo.mercator()
#'     .center([78.9629, 23.5937])
#'     .scale(1000);
#'     var path = d3.geo.path().projection(projection);
#'     return { path: path, projection: projection };
#'   }
#'   ')
#'   )
#' 
#' @seealso \href{documentation}{https://github.com/Anujarya300/bubble_maps}
#' 
#' @export
set_projection <- function(p, fun = htmlwidgets::JS()){
  if(missing(p) || missing(fun))
    stop("must pass p and fun", call. = FALSE)
  
  p$x$setProjection <- fun
  p
}