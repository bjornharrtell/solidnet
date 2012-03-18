define [
  'cs!WKTJSON'
], (WKTJSON) ->
  class Map
    constructor: ->
      @map = map = new OpenLayers.Map null
      @map.addLayer new OpenLayers.Layer.OSM
      @map.setCenter(
        new OpenLayers.LonLat(-71.147, 42.472).transform(
          new OpenLayers.Projection("EPSG:4326"),
          this.map.getProjectionObject()
        ), 12)
      
      layer = new OpenLayers.Layer.Vector '',
        protocol: new OpenLayers.Protocol.HTTP
          url: 'links'
          format: new WKTJSON
        strategies: [new OpenLayers.Strategy.BBOX]
        projection: this.map.getProjectionObject()
        styleMap: new OpenLayers.StyleMap
          strokeWidth: 3
      @layer = layer
      @map.addLayer @layer
      @draw = new OpenLayers.Control.DrawFeature @layer, OpenLayers.Handler.Path,
        featureAdded: @onFeatureAdded
      
      @map.addControl new OpenLayers.Control.MousePosition
      @map.addControl @draw
      
    onFeatureAdded: (feature) ->
      format = new OpenLayers.Format.WKT
      data =
        wkt: format.write feature
    
      Ext.Ajax.request
        url: 'links'
        jsonData: data
