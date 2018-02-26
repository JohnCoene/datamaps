HTMLWidgets.widget({

  name: 'datamaps',

  type: 'output',

  factory: function(el, width, height) {

    var chart = null;

    return {

      renderValue: function(x) {

        if(chart === null){

          chart = new Datamap({
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
            chart.bubbles(x.bubbles);
          }

          if(x.hasOwnProperty('arcs')){
            chart.arc(x.arcs);
          }

          if(x.hasOwnProperty('legend')){
            chart.legend();
          }

          if(x.hasOwnProperty('labels')){
            chart.labels(x.labels.options);
          }

          if(x.hasOwnProperty('graticule')){
            chart.graticule();
          }
        }

      },

      getChart: function(){
        return chart;
      },

      resize: function(width, height) {

        $(window).on('resize', function() {
           chart.resize();
        });

      }

    };
  }
});

function getDatamapsObj(id){

  // Get the HTMLWidgets object
  var htmlWidgetsObj = HTMLWidgets.find("#" + id);

  var datamapID = htmlWidgetsObj.getChart();

  return(datamapID);
}

if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler('update_bubbles',
    function(data) {
      var chart = getDatamapsObj(data.id);
      chart.bubbles(data.bubbles);
  });

  Shiny.addCustomMessageHandler('update_choropleth',
    function(data) {
      var chart = getDatamapsObj(data.id);
      chart.updateChoropleth(data.update.data, data.update.reset);
  });

  Shiny.addCustomMessageHandler('update_labels',
    function(data) {
      var chart = getDatamapsObj(data.id);
      chart.labels(data.opts);
  });

  Shiny.addCustomMessageHandler('update_legend',
    function(data) {
      var chart = getDatamapsObj(data.id);
      chart.legend();
  });

  Shiny.addCustomMessageHandler('update_arcs',
    function(data) {
      var chart = getDatamapsObj(data.id);
      chart.arc(data.arcs);
  });

  Shiny.addCustomMessageHandler('delete_map',
    function(data) {
      var chart = getDatamapsObj(data.id);
      chart.remove();
  });
}
