# datamaps 0.0.3.9000

* Support for [icons](https://github.com/jdlubrano/datamaps-icons-plugin) and [marker](https://github.com/arshad/datamaps-custom-marker) plugins added.
* `longitude` and `latitude` arguments renamed to `lon` and `lat` respectively.

# datamaps 0.0.2

* Better shiny reactivity
* Resizing - `datamaps` init default `responsive = TRUE` and `width`, `height` to `100%`
* Bug where the map would get redrawn on input change in Shiny fixed.
* Fixed `shiny` bug where map would get redrawn instead of updated.
* Added support for custom [topo.json](https://github.com/topojson/topojson), see `set_projection`
