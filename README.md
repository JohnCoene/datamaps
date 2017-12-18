# datamaps

[![Travis-CI Build Status](https://travis-ci.org/JohnCoene/datamaps.svg?branch=master)](https://travis-ci.org/JohnCoene/datamaps)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/JohnCoene/datamaps?branch=master&svg=true)](https://ci.appveyor.com/project/JohnCoene/datamaps)

![datamaps](http://john-coene.com/img/datamaps_proxy.gif)

R htmlwidget for [datamaps](http://datamaps.github.io/).

## Installation

```R
# install.packages("devtools")
devtools::install_github("JohnCoene/datamaps")
```

## Info

* See [website](http://john-coene.com/datamaps) for demos. 
* Includes proxies to update the visualisation without re-drawing entire map.

## Examples

Example proxy.

```R
library(shiny)

ui <- fluidPage(

  textInput(
    "from",
    "Origin",
    value = "USA"
  ),
  textInput(
    "to",
    "Destination",
    value = "RUS"
  ),
  actionButton(
    "submit",
    "Draw arc"
  ),
  datamapsOutput("map")
)

server <- function(input, output){

  arc <- reactive({
    data.frame(from = input$from, to = input$to)
  })

 output$map <- renderDatamaps({
   datamaps()
 })

 observeEvent(input$submit, {
   datamapsProxy("map") %>%
     add_data(arc()) %>%
     update_arcs_name(from, to)
 })

}

shinyApp(ui, server)
}
```
