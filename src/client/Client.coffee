define [
  'cs!Map'
  'cs!MapPanel'
], (Map, MapPanel)->
  Ext.onReady ->
    map = new Map
    mapPanel = new MapPanel(map.map)

    Ext.create 'Ext.Viewport'
      layout:
        type: 'fit'
      items: mapPanel.panel

