define ->
  class Map
    constructor: ->
      @map = new OpenLayers.Map
      @map.addLayer new OpenLayers.Layer.OSM
      @map.setCenter(
        new OpenLayers.LonLat(-71.147, 42.472).transform(
          new OpenLayers.Projection("EPSG:4326"),
          this.map.getProjectionObject()
        ), 12)
      @map.addControl new OpenLayers.Control.MousePosition
