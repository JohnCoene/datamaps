#' Add icons
#' 
#' Add icons at coordinates.
#' 
#' @param p a datamaps object.
#' @param lon,lat coordinates.
#' @param class a valid CSS class.
#' @param ... any other parameter.
#' 
#' @examples 
#' coords <- data.frame(
#'   city = c("London", "New York", "Beijing", "Sydney"),
#'   lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
#'   lat = c(51.49999, 40.74998, 39.92889, -33.92001)
#' )
#' 
#' coords %>% 
#'   datamaps() %>% 
#'   add_icons(lon, lat)
#'                      
#' @seealso \href{https://github.com/jdlubrano/datamaps-icons-plugin}{Plugin documentation}
#' 
#' @rdname icons-plugin
#' @export
add_icons <- function(p, lon, lat, ...){
  
  if(missing(lon) || missing(lat))
    stop("missing coordinates", call. = FALSE)
  
  if(!length(p$x$iconsOpts))
    p <- icons_options(p)
  
  data <- icons_data_(deparse(substitute(lon)), deparse(substitute(lat)), ...)
  
  p$x$iconsData <- append(p$x$arcs, data)
  p
}

#' @rdname icons-plugin
#' @export
icons_options <- function(p, class = "datamaps-icon", ...){
  
  opts <- list(...)
  opts$cssClass <- class
  
  p$x$iconsOpts <- append(p$x$arcs, opts)
  p
}

#' Add markers
#' 
#' Add custom markers at coordinates.
#' 
#' @param p a datamaps object.
#' @param lon,lat coordinates.
#' @param ... any other parameter.
#' 
#' @note Icons may not show in RStudio viewer, open in browser.
#' 
#' @examples 
#' coords <- data.frame(
#'   city = c("London", "New York", "Beijing", "Sydney"),
#'   lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
#'   lat = c(51.49999, 40.74998, 39.92889, -33.92001),
#'   radius = runif(4, 5, 17)
#' )
#' 
#' icon_url <- paste0(
#'   "https://pbs.twimg.com/profile_images/",
#'   "927645314630193158/ufoYTbbi_400x400.jpg"
#' )
#' 
#' coords %>% 
#'   datamaps() %>% 
#'   markers_options(
#'     icon = list(
#'       url = icon_url,
#'       width = 20, height = 20
#'      ),
#'      fillOpacity = 1
#'   ) %>% 
#'   add_markers(lon, lat)
#'   
#' @seealso \href{https://github.com/arshad/datamaps-custom-marker}{Plugin documentation}
#' 
#' @rdname markers-plugin
#' @export
add_markers <- function(p, lon, lat, ...){
  
  if(missing(lon) || missing(lat))
    stop("missing coordinates", call. = FALSE)
  
  if(!length(p$x$customMarkersOptions))
    warning("no marker setup", call. = FALSE)
  
  if(!length(p$x$customMarkersData))
    p$x$customMarkersData <- list()
  
  data <- markers_data_(
    deparse(substitute(lon)), 
    deparse(substitute(lat)), 
    ...
  )
  
  p$x$customMarkersData <- append(p$x$customMarkersData, data)
  
  p
}

#' @rdname markers-plugin
#' @export
markers_options <- function(p, ...){
  
  if(!length(p$x$customMarkersOptions))
    p$x$customMarkersOptions <- list()
  
  p$x$customMarkersOptions <- append(p$x$customMarkersOptions, list(...))
  p
}