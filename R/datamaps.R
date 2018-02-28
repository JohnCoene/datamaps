#' Initiate map
#'
#' Setup a datamaps chart.
#'
#' @param data data.frame.
#' @param scope map scope.
#' @param default default color for missing values.
#' @param projection map projection.
#' @param responsive whether for map to be responsive.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId DOM id.
#'
#' @examples
#' datamaps(projection = "orthographic") %>%
#'   add_graticule()
#'
#' @import htmlwidgets
#' @importFrom grDevices colorRampPalette
#'
#' @rdname datamaps
#' @export
datamaps <- function(data, scope = "world", default = "#ABDDA4", projection = "equirectangular", responsive = FALSE, width = NULL,
                     height = NULL, elementId = NULL) {

  if(!missing(data))
    assign("data", data, envir = data_env)

  if(!tolower(scope) %in% c("usa", "world")) stop("incorrect scope, see details", call. = FALSE)

  # forward options using x
  x = list(
    responsive = responsive,
    scope = tolower(scope),
    projection = projection,
    fills = list(defaultFill = default),
    geographyConfig = list(dataUrl = NULL)
    #,bubblesConfig = list(key = "JSON.stringify")
  )

  attr(x, 'TOJSON_ARGS') <- list(keep_vec_names = TRUE)

  # create widget
  htmlwidgets::createWidget(
    name = 'datamaps',
    x,
    width = width,
    height = height,
    package = 'datamaps',
    elementId = elementId
  )
}

#' Shiny bindings for datamaps
#'
#' Output and render functions for using datamaps within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a datamaps
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#' @param id id of map.
#' @param session shiny session.
#'
#' @name datamaps-shiny
#'
#' @export
datamapsOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'datamaps', width, height, package = 'datamaps')
}

#' @rdname datamaps-shiny
#' @export
renderDatamaps <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, datamapsOutput, env, quoted = TRUE)
}

#' @rdname datamaps-shiny
#' @export
datamapsProxy <- function(id, session = shiny::getDefaultReactiveDomain()){

  proxy <- list(id = id, session = session)
  class(proxy) <- "datamapsProxy"

  return(proxy)
}
