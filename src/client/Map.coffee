define ->
  class Map
    constructor: ->
      @map = map = new OpenLayers.Map
        controls: []
      @map.addLayer new OpenLayers.Layer.OSM
      @map.setCenter(
        new OpenLayers.LonLat(-71.147, 42.472).transform(
          new OpenLayers.Projection("EPSG:4326"),
          this.map.getProjectionObject()
        ), 12)
      
      layer = new OpenLayers.Layer.Vector
      @layer = layer
      @map.addLayer @layer
      @draw = new OpenLayers.Control.DrawFeature @layer, OpenLayers.Handler.Path,
        featureAdded: @onFeatureAdded
      
      @map.addControl new OpenLayers.Control.MousePosition
      @map.addControl @draw
      
      bounds = map.getExtent()
      
      Ext.Ajax.request
        url: 'links?bbox=' + 
          bounds.left + ' ' +
          bounds.bottom + ',' +
          bounds.right + ' ' + 
          bounds.top
        success: (res) ->
          format = new OpenLayers.Format.WKT
          for link in res
            feature = format.read(link.wkt)
            layer.addFeature(feature)
    
    onFeatureAdded: (feature) ->
      format = new OpenLayers.Format.WKT
      data =
        wkt: format.write feature
    
      Ext.Ajax.request
        url: 'links'
        jsonData: data
