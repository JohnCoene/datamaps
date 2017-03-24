HTMLWidgets.widget({

  name: 'datamaps',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var choro = new Datamap({
            element: document.getElementById(el.id),
            scope: x.scope,
            fills: x.fills,
            data: x.data
        });

        if(x.hasOwnProperty('legend')){
          choro.legend();
        }
        if(x.hasOwnProperty('labels')){
          choro.labels();
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
