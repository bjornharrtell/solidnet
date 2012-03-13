define ->
  class MapManel
    constructor: (@map) ->
      map = @map
  
      @panel = Ext.create 'Ext.panel.Panel'
        title: 'Map'
        tbar: ['-', {text: 'button'}]
        listeners:
          afterlayout:
            fn: ->
              map.render @body.dom
