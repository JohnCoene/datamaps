#' Dynamically add bubbles
#'
#' Dynamically add bubble using Shiny.
#'
#' @param proxy a proxy as returned by \code{\link{datamapsProxy}}.
#' @param longitude,latitude coordinates of bubbles.
#' @param radius radius of bubbles.
#' @param color color of bubbles.
#' @param name name of bubbles.
#' @param ... any other variable to use in tooltip.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'  numericInput(
#'    "lon",
#'    "Longitude",
#'    value = 50
#'  ),
#'  numericInput(
#'    "lat",
#'    "Latitude",
#'    value = 50
#'  ),
#'  textInput(
#'    "city",
#'    "City",
#'    value = "City"
#'  ),
#'  sliderInput(
#'    "value",
#'    "Value",
#'    min = 1,
#'    max = 4,
#'    step = 1,
#'    value = 3
#'  ),
#'  actionButton(
#'    "sub",
#'    "Submit"
#'  ),
#'  datamapsOutput("map")
#' )
#'
#' server <- function(input, output){
#'
#'   coords <- data.frame(city = c("London", "New York", "Beijing", "Sydney"),
#'                        lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
#'                        lat = c(51.49999, 40.74998, 39.92889, -33.92001),
#'                        values = 1:4)
#'
#'   update <- reactive({
#'     df <- data.frame(city = input$city, lon = input$lon, lat = input$lat, values = input$value)
#'     rbind.data.frame(coords, df)
#'   })
#'
#'   output$map <- renderDatamaps({
#'     coords %>%
#'       datamaps() %>%
#'       add_bubbles(lon, lat, values * 2, values, city)
#'   })
#'
#'   observeEvent(input$sub, {
#'     datamapsProxy("map") %>%
#'       add_data(update()) %>% # pass updated data
#'       update_bubbles(lon, lat, values * 2, values, city) # update
#'   })
#'
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
update_bubbles <- function(proxy, longitude, latitude, radius, color, name, ...){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  data <- get("data", envir = data_env)
  col <- eval(substitute(color), data)
  lon <- eval(substitute(longitude), data)
  lat <- eval(substitute(latitude), data)
  rad <- eval(substitute(radius), data)
  nam <- eval(substitute(name), data)

  bubbles <- bubbles_data_(lon, lat, rad, col, nam, ...)

  data <- list(id = proxy$id, bubbles = bubbles)

  proxy$session$sendCustomMessage("update_bubbles", data)

  return(proxy)
}

#' Dynamically add bubbles
#'
#' Dynamically add bubbles using Shiny.
#'
#' @param proxy a proxy as returned by \code{\link{datamapsProxy}}.
#' @param locations column containing location names as \code{iso3c}.
#' @param color column containing color of each \code{location}.
#' @param reset reset previous changes to \code{default} color from \code{\link{datamaps}}.
#' @param ... any other variable to use for tooltip.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'   selectInput(
#'     "countrySelect",
#'     "Select Country",
#'     choices = c("USA", "FRA", "CHN", "RUS", "COG", "DZA", "BRA", "IND")
#'   ),
#'   sliderInput(
#'     "value",
#'     "Value",
#'     min = 1,
#'     max = 10,
#'     value = 5
#'   ),
#'   actionButton("update", "Update"),
#'   datamapsOutput("map")
#' )
#'
#' server <- function(input, output){
#'
#'   data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA", "BRA", "IND", "ALG", "AFG"),
#'                      color = 1:10)
#'
#'  updated_data <- reactive({
#'    data.frame(name = input$countrySelect, value = input$value)
#'  })
#'
#'   output$map <- renderDatamaps({
#'     data %>%
#'       datamaps() %>%
#'       add_choropleth(name, color)
#'   })
#'
#'   observeEvent(input$update, {
#'     datamapsProxy("map") %>%
#'       add_data(updated_data()) %>% # pass updated data
#'       update_choropleth(name, value, TRUE) # update
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
update_choropleth <- function(proxy, locations, color, reset = FALSE, ...){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  if(missing(locations) || missing(color))
    stop("missing locations & color")

  data <- get("data", envir = data_env)
  loc <- eval(substitute(locations), data)
  col <- eval(substitute(color), data)
  update <- choro_data_(loc, col, ...)

  data <- list(id = proxy$id, update = list(data = update, reset = reset))

  proxy$session$sendCustomMessage("update_choropleth", data)

  return(proxy)
}

#' Dynamically update labels
#'
#' Dynamically update labels using Shiny
#'
#' @param proxy a proxy as returned by \code{\link{datamapsProxy}}.
#' @param label.color color of label.
#' @param line.width with of line.
#' @param font.size size of font label.
#' @param font.family family of font label.
#' @param ... any other option.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'   actionButton(
#'     "update",
#'     "update labels"
#'   ),
#'   datamapsOutput("map")
#' )
#'
#' server <- function(input, output){
#'   states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
#'                        val = c(10, 5, 3, 8, 6, 7, 2))
#'
#'   output$map <- renderDatamaps({
#'     states %>%
#'       datamaps(scope = "usa", default = "lightgray") %>%
#'       add_choropleth(st, val) %>% 
#'       add_labels()
#'   })
#'
#'   observeEvent(input$update, {
#'     datamapsProxy("map") %>%
#'       update_labels(sample(c("blue", "red", "orange", "green", "white"), 1)) # update
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
update_labels <- function(proxy, label.color = "#000", line.width = 1, font.size = 10, font.family = "Verdana", ...){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  opts <- list(...)
  opts$labelColor <- label.color
  opts$lineWidth <- line.width
  opts$fontSize <- font.size
  opts$fontFamily <- font.family

  data <- list(id = proxy$id, opts = opts)

  proxy$session$sendCustomMessage("update_labels", data)

  return(proxy)
}

#' Dynamically update legend
#'
#' Dynamically update legend using Shiny
#'
#' @param proxy a proxy as returned by \code{\link{datamapsProxy}}.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'   actionButton(
#'     "show",
#'     "Show legend"
#'   ),
#'   datamapsOutput("map")
#' )
#'
#' server <- function(input, output){
#'   states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
#'                        val = c(10, 5, 3, 8, 6, 7, 2))
#'
#'   output$map <- renderDatamaps({
#'     states %>%
#'       datamaps(scope = "usa", default = "lightgray") %>%
#'       add_choropleth(st, val)
#'   })
#'
#'   observeEvent(input$update, {
#'     datamapsProxy("map") %>%
#'       update_legend() # update
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
update_legend <- function(proxy){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  data <- list(id = proxy$id)

  proxy$session$sendCustomMessage("update_legend", data)

  return(proxy)
}


#' Dynamically update arcs
#'
#' Dynamically update arcs with Shiny.
#'
#' @param proxy a proxy as returned by \code{\link{datamapsProxy}}.
#' @inheritParams add_arcs
#' @inheritParams add_arcs_name
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'
#'   textInput(
#'     "from",
#'     "Origin",
#'     value = "USA"
#'   ),
#'   textInput(
#'     "to",
#'     "Destination",
#'     value = "RUS"
#'   ),
#'   actionButton(
#'     "submit",
#'     "Draw arc"
#'   ),
#'   datamapsOutput("map")
#' )
#'
#' server <- function(input, output){
#'
#'   arc <- reactive({
#'     data.frame(from = input$from, to = input$to)
#'   })
#'
#'  output$map <- renderDatamaps({
#'    datamaps()
#'  })
#'
#'  observeEvent(input$submit, {
#'    datamapsProxy("map") %>%
#'      add_data(arc()) %>%
#'      update_arcs_name(from, to)
#'  })
#'
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @rdname update_arcs
#' @export
update_arcs <- function(proxy, origin.lon, origin.lat, destination.lon, destination.lat, ...){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  data <- get("data", envir = data_env)
  ori.lon <- eval(substitute(origin.lon), data)
  ori.lat <- eval(substitute(origin.lat), data)
  des.lon <- eval(substitute(destination.lon), data)
  des.lat <- eval(substitute(destination.lat), data)

  data <- list(id = proxy$id, arcs = arc_data__(ori.lon, ori.lat, des.lon, des.lat, ...))

  proxy$session$sendCustomMessage("update_arcs", data)

  return(proxy)
}

#' @rdname update_arcs
#' @export
update_arcs_name <- function(proxy, origin, destination, ...){

  data <- get("data", envir = data_env)
  ori <- eval(substitute(origin), data)
  des <- eval(substitute(destination), data)

  msg <- list(id = proxy$id, arcs = arc_data_(ori, des, ...))

  print(msg)

  proxy$session$sendCustomMessage("update_arcs", msg)

  return(proxy)
}

#' Remove map
#'
#' Remove the map
#'
#' @param proxy a proxy as returned by \code{\link{datamapsProxy}}.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'   actionButton(
#'     "delete",
#'     "Delete map"
#'   ),
#'   datamapsOutput("map")
#' )
#'
#' server <- function(input, output){
#'   output$map <- renderDatamaps({
#'     datamaps()
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
delete_map <- function(proxy){

  msg <- list(id = proxy$id)

  proxy$session$sendCustomMessage("delete_map", msg)

  return(proxy)
}
