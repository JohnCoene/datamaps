# datamaps 0.0.2

* Better shiny reactivity
* Resizing - `datamaps` init default `responsive = TRUE` and `width`, `height` to `100%`
* Bug where the map would get redrawn on input change in Shiny fixed.
* Fixed `shiny` bug where map would get redrawn instead of updated.
* Added support for custom [topo.json](https://github.com/topojson/topojson), see `set_projection`
