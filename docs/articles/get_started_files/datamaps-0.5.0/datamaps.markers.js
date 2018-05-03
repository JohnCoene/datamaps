/**
  * @file
* Adds a custom plugin to handle map markers.
*/
  (function() {
    if (typeof Datamap !== 'undefined') {
      // Handler custom markers.
      Datamap.customMarkers = function (layer, data, options) {
        var self = this,
        fillData = this.options.fills,
        svg = this.svg;
        
        // Check for map data.
        if (!data || (data && !data.slice)) {
          throw "Datamaps Error - markers must be an array";
        }
        
        // Build markers.
        var markers = layer
        .selectAll('image.datamaps-markers')
        .data(data, JSON.stringify);
        
        markers
        .enter()
        .append('image')
        .attr('class', 'datamaps-marker')
        .attr('xlink:href', options.icon.url)
        .attr('width', options.icon.width)
        .attr('height', options.icon.height)
        .attr('x', function (markerData) {
          var latLng;
          if (markerHasCoordinates(markerData)) {
            latLng = self.latLngToXY(markerData.latitude, markerData.longitude);
          }
          else if (markerData.centered) {
            latLng = self.path.centroid(svg.select('path.' + markerData.centered).data()[0]);
          }
          if (latLng) return (latLng[0] - (options.icon.width / 2));
        })
        .attr('y', function (markerData) {
          var latLng;
          if (markerHasCoordinates(markerData)) {
            latLng = self.latLngToXY(markerData.latitude, markerData.longitude);
          }
          else if (markerData.centered) {
            latLng = self.path.centroid(svg.select('path.' + markerData.centered).data()[0]);
          }
          if (latLng) return (latLng[1] - options.icon.height);
        })
        .on('mouseover', function (markerData) {
          var $this = d3.select(this);
          if (options.popupOnHover) {
            self.updatePopup($this, markerData, options, svg);
          }
        })
        .on('mouseout', function (markerData) {
          var $this = d3.select(this);
          if (options.highlightOnHover) {
            // Reapply previous attributes.
            var previousAttributes = JSON.parse($this.attr('data-previousAttributes'));
            for (var attr in previousAttributes) {
              $this.style(attr, previousAttributes[attr]);
            }
          }
          d3.selectAll('.datamaps-hoverover').style('display', 'none');
        })
        
        markers.exit()
        .transition()
        .delay(options.exitDelay)
        .attr("height", 0)
        .remove();
        
        // Checks if a marker has latitude and longitude provided.
        function markerHasCoordinates(markerData) {
          return typeof markerData !== 'undefined' && typeof markerData.latitude !== 'undefined' && typeof markerData.longitude !== 'undefined';
        }
      }
    }
  })();