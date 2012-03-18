define ->
  class MapManel
    constructor: (map) ->
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
            fn: ->
              map.map.render @body.dom
