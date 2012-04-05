Log = require 'log'
log  = new Log

log.debug 'Server initializing...'
fs = require 'fs'
express = require 'express'
pg = require 'pg'

log.debug 'Reading environment variables...'
env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'))

connstring = env['DOTCLOUD_DATA_SQL_URL'] + '/solidnet'

log.debug "Connecting to PostgreSQL using connection string: #{connstring}"
pg.connect connstring, (err, client) ->

  if err?
    log.emergency "Connection failed: #{err}"
    return

  client.query "set search_path to solidnet,public;"

  parseBBOX = (bbox) ->
    bbox = bbox.split ','
    "'BOX(#{bbox[0]} #{bbox[1]},#{bbox[2]} #{bbox[3]}'::box2d"

  log.debug 'Creating express server...'
  app = express.createServer()
  
  sendResult = 

  app.configure ->
    app.use express.static __dirname + '../../../'
    app.use express.bodyParser()

  app.get '/hello', (req, res) =>
    res.send 'hello world' 

  app.get '/links', (req, res) =>
    log.debug 'Got query for links...'
    query = "SELECT id, ST_AsText(geom) AS wkt FROM links WHERE geom && " + parseBBOX(req.query.bbox)
    client.query query, (err, result) ->
      if result? then res.send result.rows

  app.post '/links', (req, res) =>
    client.query "SELECT createlink($1)", [req.body.wkt]
    res.send 'ok'    

  app.get '/linkports', (req, res) =>
    query = "SELECT id, distance, ST_AsText(geom) AS wkt FROM linkports WHERE geom && " + parseBBOX(req.query.bbox)
    client.query query, (err, result) ->
      res.send result.rows
      
  app.post '/linkports', (req, res) =>
    client.query "SELECT createport($1, $2)", [req.body.id, req.body.wkt]
    res.send 'ok'
      
  app.get '/nodes', (req, res) =>
    query = "SELECT id, ST_AsText(geom) AS wkt FROM nodes WHERE geom && " + parseBBOX(req.query.bbox)
    client.query query, (err, result) ->
      res.send result.rows
      
  app.post '/nodes', (req, res) =>
    client.query "SELECT createnode($1)", [req.body.wkt]
    res.send 'ok'

  log.debug 'Listening to port 8080...'
  app.listen 8080

