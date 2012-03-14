define ->
  class MapManel
    constructor: (map) ->
      @panel = Ext.create 'Ext.panel.Panel'
        title: 'Map'
        tbar: [
          '-'
        , 
          text: 'button'
          enableToggle: true
          listeners:
            toggle:
              fn: (button, pressed) ->
                if pressed then map.draw.activate() else map.draw.deactivate()
        ]
        listeners:
          afterlayout:
            fn: ->
              map.map.render @body.dom
