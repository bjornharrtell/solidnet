define ->
  format = new OpenLayers.Format.WKT()

  WKTJSON = OpenLayers.Class OpenLayers.Format.JSON,
    read: (json) ->
      objects = OpenLayers.Format.JSON.prototype.read.call this, json
      features = []
      for object in objects
        feature = format.read object.wkt
        feature.attributes = object
        features.push feature
      features
