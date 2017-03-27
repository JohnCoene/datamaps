HTMLWidgets.widget({

  name: 'datamaps',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var map = new Datamap({
            element: document.getElementById(el.id),
            scope: x.scope,
            projection: x.projection,
            responsive: x.responsive,
            geographyConfig: x.geographyConfig,
            bubblesConfig: x.bubblesConfig,
            arcConfig: x.arcConfig,
            fills: x.fills,
            data: x.data
        });

        if(x.hasOwnProperty('bubbles')){
          map.bubbles(x.bubbles);
        }

        if(x.hasOwnProperty('arcs')){
          map.arc(x.arcs);
        }

        if(x.hasOwnProperty('legend')){
          map.legend();
        }

        if(x.hasOwnProperty('labels')){
          map.labels();
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
