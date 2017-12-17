#' Dynamically add bubbles
#'
#' Dynamically add bubble using Shiny.
#'
#' @examples
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
#'    max = 10,
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

  print(data)

  proxy$session$sendCustomMessage("update_bubbles", data)

  return(proxy)
}

#' Dynamically add bubbles
#'
#' Dynamically add bubbles using Shiny.
#'
#' @examples
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

  print(update)

  proxy$session$sendCustomMessage("update_choropleth", data)

  return(proxy)
}

#' Dynamically update labels
#'
#' Dynamically update labels using Shiny
#'
#' @examples
#' library(shiny)
#'
#' ui <- fluidPage(
#'   actionButton(
#'     "show",
#'     "Show labels"
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
#'       update_labels() # update
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' @export
update_labels <- function(proxy){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  data <- list(id = proxy$id)

  proxy$session$sendCustomMessage("update_labels", data)

  return(proxy)
}

#' Dynamically update legend
#'
#' Dynamically update legend using Shiny
#'
#' @examples
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
#' @export
update_arcs <- function(p, origin.lon, origin.lat, destination.lon, destination.lat, ...){

  if(!inherits(proxy, "datamapsProxy"))
    stop("must pass proxy, see datamapsProxy.")

  data <- get("data", envir = data_env)
  ori.lon <- eval(substitute(origin.lon), data)
  ori.lat <- eval(substitute(origin.lat), data)
  des.lon <- eval(substitute(destination.lon), data)
  des.lat <- eval(substitute(destination.lat), data)

  data <- list(id = , arcs = arc_data__(ori.lon, ori.lat, des.lon, des.lat, ...))

  proxy$session$sendCustomMessage("update_arcs", data)

  return(proxy)
}
