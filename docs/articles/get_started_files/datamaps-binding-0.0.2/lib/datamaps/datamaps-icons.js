// datamaps-icons.js
// Author: Joel Lubrano
// The datamaps icons plugin.

"use strict";

(function() {
  
  var PLUGIN_NAME = 'icons';
  
  var iconsPlugin = function(layer, data, options) {
    var SVG_NS = 'http://www.w3.org/2000/svg';
    var self = this;
    
    var defaultOptions = {
      cssClass: 'datamap-icon',
      iconFn: function() {
        // default to a black circle.
        var circle = document.createElementNS(SVG_NS, 'circle');
        circle.setAttribute('r', 5);
        circle.setAttribute('stroke', '#000');
        circle.setAttribute('stroke-width', 1);
        circle.setAttribute('fill', '#000');
        return circle;
      },
      hover: {
        overFn: null,
        overClass: 'hover-over',
        outFn: null,
        outClass: 'hover-out'
      },
      click: {
        allowMultiple: false,
        onFn: null,
        onClass: 'click-on',
        offFn: null,
        offClass: 'click-off',
        awayFromIconFn: null,
        clickOffOnClickAway: false
      }
    };
    
    var dispatch = d3.dispatch(
      'hoverOver',
      'hoverOut',
      'clickOn',
      'clickOff',
      'clickAwayFromIcon'
    );
    
    var overrideProps = function(orig, addition) {
      // add the properties from orig that 
      // do not already exist in addition.
      for(var prop in orig) {
        if(typeof orig[prop] === "object" && addition[prop]) {
          overrideProps(orig[prop], addition[prop]);
        } else {
          if(addition[prop] == null) addition[prop] = orig[prop];
        }
      }
      return addition;
    };
    
    var lngToX = function(d) {
      return self.latLngToXY(d.lat, d.lng)[0];
    };
    
    var latToY = function(d) {
      return self.latLngToXY(d.lat, d.lng)[1];
    };
    
    var isCircle = function(elem) {
      return elem.tagName === 'circle';
    };
    
    var genTranslateStr = function(d, i) {
      // Unless the element is a circle,
      // SVG translations place the top-left corner of the element at (x,y).
      // Ideally, the icon would be centered at (x,y) so we must compensate
      // by centering the SVG bounding box.
      var centerX = lngToX(d);
      var centerY = latToY(d);
      if(!isCircle(this)) {
        var bbox = this.getBBox();
        centerX -= bbox.width / 2;
        centerY -= bbox.height / 2;
      }
      return 'translate(' + centerX + ',' + centerY + ')';
    };
    
    var resolveIcon = function(d, i) {
      // Look for an icon DOM element stored in the data.
      // Fallback to a function that returns a DOM element defined
      // in options.
      if(d.icon) return d.icon;
      if(options.iconFn) return options.iconFn.call(this, d, i);
      throw new Error(
        "An icon must be specified as DOM element in the data point's icon" +
          " field or a function that returns icon DOM elements must be provided" +
          " in options.iconFn."
      );
    };
    
    var resolveCssClass = function(el, cssClass) {
      // if d.cssClass is defined, then append d.cssClass to
      // the existing class attribute.
      var currentClass = el.getAttribute('class');
      var selection = d3.select(el);
      if(cssClass && !selection.classed(cssClass)) {
        currentClass += ' ' + cssClass;
      }
      return currentClass;
    };
    
    var resolveIconCssClass = function(d, i) {
      return resolveCssClass(this, d.cssClass);
    };
    
    var resolveHoverOverCssClass = function(el, d) {
      var cssClass = options.hover.overClass;
      if(d.hover) {
        cssClass = d.hover.overClass ? d.hover.overClass : cssClass;
      }
      return cssClass;
    };
    
    var resolveHoverOutCssClass = function(el, d) {
      var cssClass = options.hover.outClass;
      if(d.hover) {
        cssClass = d.hover.outClass ? d.hover.outClass : cssClass;
      }
      return cssClass;
    };
    
    var applyHoverCssClasses = function(el, d, hoverOn) {
      var selection = d3.select(el);
      selection.classed(resolveHoverOverCssClass(el, d), hoverOn);
      selection.classed(resolveHoverOutCssClass(el, d), !hoverOn);
    };
    
    var getSelection = function() {
      return layer.selectAll('.' + options.cssClass);
    };
    
    var getState = function() {
      return self.state;
    };
    
    var setupHoverListeners = function() {
      
      var icons = getSelection();
      
      dispatch.on("hoverOver.icon", options.hover.overFn);
      dispatch.on("hoverOut.icon", options.hover.outFn);
      
      icons.on("mouseover", function(d, i) {
        applyHoverCssClasses(this, d, true);
        dispatch.hoverOver.apply(this, [d, i]);
      });
      
      icons.on("mouseout", function(d, i) {
        applyHoverCssClasses(this, d, false);
        dispatch.hoverOut.apply(this, [d, i]);
      });
    };
    
    var resolveClickOnCssClass = function(d) {
      var cssClass = options.click.onClass;
      if(d.click) {
        cssClass = d.click.onClass ? d.click.onClass : cssClass;
      }
      return cssClass;
    };
    
    var resolveClickOffCssClass = function(d) {
      var cssClass = options.click.offClass;
      if(d.click) {
        cssClass = d.click.offClass ? d.click.offClass : cssClass;
      }
      return cssClass;
    };
    
    var getClickedIcons = function() {
      var inClickOnState = [];
      getSelection().each(function(d, i) {
        var clickOnCssClass = resolveClickOnCssClass(d);
        if(d3.select(this).classed(clickOnCssClass)) {
          inClickOnState.push(this);
        }
      });
      return inClickOnState;
    };
    
    var getClickedIcon = function() {
      return getClickedIcons()[0];
    };
    
    var iconInClickedState = function(iconElement) {
      return getClickedIcons().indexOf(iconElement) !== -1;
    };
    
    var applyClickCssClassToIcon = function(iconElement, clickOn) {
      var selection = d3.select(iconElement);
      var d = selection.data()[0]; // selection.data() produces an array of data.
      var clickOnCssClass = resolveClickOnCssClass(d);
      var clickOffCssClass = resolveClickOffCssClass(d);
      selection.classed(clickOnCssClass, clickOn);
      selection.classed(clickOffCssClass, !clickOn);
      return selection;
    };
    
    var applyClickOnToIcon = function(iconElement) {
      var selection = applyClickCssClassToIcon(iconElement, true);
      dispatch.clickOn.apply(iconElement, selection.data());
    };
    
    var applyClickOffToIcon = function(iconElement) {
      if(!iconElement) return;
      var selection = applyClickCssClassToIcon(iconElement, false);
      dispatch.clickOff.apply(iconElement, selection.data());
    };
    
    var unclickAllIcons = function() {
      getClickedIcons().forEach(applyClickOffToIcon);
    };
    
    var setupIconClickListeners = function() {
      var icons = getSelection();
      
      dispatch.on('clickOn.icon', options.click.onFn);
      dispatch.on('clickOff.icon', options.click.offFn);
      
      icons.on("click", function(d, i) {
        d3.event.stopPropagation(); // stop from bubbling to svg
        var alreadyInClickedState = iconInClickedState(this);
        if(options.click.allowMultiple) {
          if(alreadyInClickedState) {
            applyClickOffToIcon(this);
          } else {
            applyClickOnToIcon(this);
          }
        } else {
          applyClickOffToIcon(getClickedIcon());
          if(!alreadyInClickedState) {
            applyClickOnToIcon(this);
          }
        }
      });
    };
    
    var setupClickAwayFromIconListener = function() {
      dispatch.on('clickAwayFromIcon.svg', options.click.awayFromIconFn);
      self.svg.on('click', function(d, i) {
        dispatch.clickAwayFromIcon.apply(self);
        if(options.click.clickOffOnClickAway) {
          unclickAllIcons();
        }
      });
    };
    
    var setupClickListeners = function() {
      setupIconClickListeners();
      setupClickAwayFromIconListener();
    };
    
    // Draw icons layer
    
    options = overrideProps(defaultOptions, options);
    
    var icons = getSelection().data(data);
    
    icons.enter()
    .append(resolveIcon)
    .classed(options.cssClass, true)
    ;
    
    icons
    .attr('transform', genTranslateStr)
    .attr('class', resolveIconCssClass)
    ;
    
    icons.exit().remove();
    
    setupHoverListeners();
    setupClickListeners();
    
  };
  
  if(Datamap !== undefined) {
    // Adding the plugin to a Datamaps instance binds
    // to the Datamaps prototype, so we create an arbitrary
    // instance and add the icons plugin.
    var dm = new Datamap({ element: document.createElement('div') });
    dm.addPlugin(PLUGIN_NAME, iconsPlugin);
  }
  
  return iconsPlugin;
  
}());