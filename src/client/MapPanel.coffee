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
            fn: (panel) ->
              map.map.render panel.body.dom
              panel.body.on 'contextmenu', @onContextmenu, @
            scope: @
              
    onContextmenu: (e,t) ->
      e.stopEvent()
      
      menu = Ext.create 'Ext.menu.Menu',
        items: [
          text: 'Connect'
        ]
      menu.showAt e.browserEvent.x, e.browserEvent.y
