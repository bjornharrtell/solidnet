define ->
  class MapManel
    constructor: (@map) ->
      map = @map
    
      button = 
        text: 'create link'
        enableToggle: true
        listeners:
          toggle:
            fn: (button, pressed) ->
              if pressed then map.draw.activate() else map.draw.deactivate()
    
      @panel = Ext.create 'Ext.panel.Panel'
        title: 'Map'
        tbar: ['-', button]
        listeners:
          afterlayout:
            fn: (panel) ->
              map.map.render panel.body.dom
              panel.body.on 'contextmenu', @onContextmenu, @
            scope: @
              
    onContextmenu: (e,t) ->
      e.stopEvent()

      x = e.browserEvent.x
      y = e.browserEvent.y
      # fix for coords coming relative to document instead of map element
      pixel = new OpenLayers.Pixel x, y-52
      
      items = []
      
      latlon = @map.map.getLonLatFromPixel pixel
      lon = latlon.lon
      lat = latlon.lat
      point = new OpenLayers.Geometry.Point lon, lat
      
      format = new OpenLayers.Format.WKT
      
      distance = @map.map.getResolution() * 3
      
      bounds = new OpenLayers.Bounds lon - distance, lat - distance, lon + distance, lat + distance

      map = @map

      for link in @map.links.features
        if link.geometry.intersects bounds.toGeometry()
          items.push
            text: 'Create port'
            listeners:
              click:
                fn: ->
                  if not link.attributes.id? then return
                
                  Ext.Ajax.request
                    url: 'linkports'
                    jsonData:
                      id: link.attributes.id
                      wkt: format.extractGeometry(point)
                    success: ->
                      obj =
                        force: true
                      #map.links.refresh(obj)
                      #map.nodes.refresh(obj)
                      map.linkports.refresh(obj)
          break
      
      menu = Ext.create 'Ext.menu.Menu',
        items: items
      menu.showAt x, y
