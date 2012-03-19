define [
  'cs!WKTJSON'
], (WKTJSON) ->
  class Map
    constructor: ->
      @map = map = new OpenLayers.Map null
      map.addLayer new OpenLayers.Layer.OSM
      map.setCenter(
        new OpenLayers.LonLat(-71.147, 42.472).transform(
          new OpenLayers.Projection("EPSG:4326"),
          this.map.getProjectionObject()
        ), 12)
      
      @links = links = @createLinksLayer()
      map.addLayer links
      
      @nodes = nodes = @createNodesLayer()
      map.addLayer nodes
      
      @linkports = linkports = @createLinkportsLayer()
      map.addLayer linkports
      
      snap = new OpenLayers.Control.Snapping
        layer: links
        targets: [links, linkports]
        greedy: false
      snap.activate()
      
      @draw = draw = new OpenLayers.Control.DrawFeature links, OpenLayers.Handler.Path,
        featureAdded: (f) => @onFeatureAdded(f)
      
      map.addControl new OpenLayers.Control.MousePosition
      map.addControl draw
      
    createLinksLayer: ->
      style = OpenLayers.Util.extend {}, OpenLayers.Feature.Vector.style['default']
      style.strokeWidth = 1
      style.strokeColor = '#000000'
      style.strokeOpacity = 1
      layer = new OpenLayers.Layer.Vector '',
        protocol: new OpenLayers.Protocol.HTTP
          url: 'links'
          format: new WKTJSON
        strategies: [new OpenLayers.Strategy.BBOX]
        projection: @map.getProjectionObject()
        styleMap: new OpenLayers.StyleMap 
          default: style
    
    createLinkportsLayer: ->
      style = OpenLayers.Util.extend {}, OpenLayers.Feature.Vector.style['default']
      style.strokeWidth = 1
      style.strokeColor = '#000000'
      style.strokeOpacity = 1
      style.pointRadius = 2
      style.fillColor = '#0000ff'
      style.fillOpacity = 1
      #style.graphicName= 'square'
      layer = new OpenLayers.Layer.Vector '',
        protocol: new OpenLayers.Protocol.HTTP
          url: 'linkports'
          format: new WKTJSON
        strategies: [new OpenLayers.Strategy.BBOX]
        projection: @map.getProjectionObject()
        styleMap: new OpenLayers.StyleMap 
          default: style
    
    createNodesLayer: ->
      style = OpenLayers.Util.extend {}, OpenLayers.Feature.Vector.style['default']
      style.strokeWidth = 1
      style.strokeColor = '#000000'
      style.strokeOpacity = 1
      style.pointRadius = 4
      #style.graphicName= 'square'
      layer = new OpenLayers.Layer.Vector '',
        protocol: new OpenLayers.Protocol.HTTP
          url: 'nodes'
          format: new WKTJSON
        strategies: [new OpenLayers.Strategy.BBOX]
        projection: @map.getProjectionObject()
        styleMap: new OpenLayers.StyleMap 
          default: style
    
    onFeatureAdded: (feature) ->
      format = new OpenLayers.Format.WKT
      data =
        wkt: format.write feature
    
      Ext.Ajax.request
        url: 'links'
        jsonData: data
        scope: @
        success: ->
          obj =
           force: true
          #@links.refresh(obj)
          @nodes.refresh(obj)
          @linkports.refresh(obj)
          
