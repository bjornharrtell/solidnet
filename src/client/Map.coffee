define ->
  class Map
    constructor: ->
      @map = new OpenLayers.Map
        controls: []
      @map.addLayer new OpenLayers.Layer.OSM
      @map.setCenter(
        new OpenLayers.LonLat(-71.147, 42.472).transform(
          new OpenLayers.Projection("EPSG:4326"),
          this.map.getProjectionObject()
        ), 12)
        
      @layer = new OpenLayers.Layer.Vector
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
