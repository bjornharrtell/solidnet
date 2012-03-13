define [
    'cs!Map'
], (map) ->
    Ext.create 'Ext.Viewport'
        layout:
            type: 'border'
        defaults:
            split: true
        items: [{
            region: 'north'
            html: 'north'
        }, 
            xtype: 'widget.mappanel'
            tbar: ['-', {text: 'moo'}]
        ]
