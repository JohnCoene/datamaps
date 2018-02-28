# datamaps

[![Travis-CI Build Status](https://travis-ci.org/JohnCoene/datamaps.svg?branch=master)](https://travis-ci.org/JohnCoene/datamaps)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/JohnCoene/datamaps?branch=master&svg=true)](https://ci.appveyor.com/project/JohnCoene/datamaps)

![datamaps](http://john-coene.com/img/datamaps_proxy.gif)

R htmlwidget for [datamaps](http://datamaps.github.io/), plot choropleth, overlay arcs and bubbles, customise options, easily interact with Shiny proxies.

* [Installation](#installation)
* [Details](#info)
* [Examples](#examples)
* [Shiny Proxies](#shiny-proxies)
* [Proxies demo](http://shiny.john-coene.com/datamaps/)

## Installation

```R
# install.packages("devtools")
devtools::install_github("JohnCoene/datamaps")
```

## Info

* See [website](http://john-coene.com/datamaps) for demos. 
* Includes proxies to update the visualisation without re-drawing entire map.

## Shiny Proxies

* `update_bubbles` - update bubbles.
* `update_choropleth` - update choropleth values.
* `update_labels` - update labels.
* `update_legend` - update the legend.
* `update_arcs` - update arcs by coordinates.
* `update_arcs_name` - update arcs by name.
* `delete_map` - delete the map.

## Examples

Example proxy.

[demo](http://shiny.john-coene.com/datamaps/)

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
