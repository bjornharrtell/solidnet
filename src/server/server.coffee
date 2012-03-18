express = require 'express'
pg = require 'pg'

client = new pg.Client 'tcp://postgres:postgres@localhost/solidnet'
client.connect()

client.query "set search_path to solidnet,public;"

app = express.createServer()

app.configure =>
  app.use express.static '/home/bjorn/code/solidnet'
  app.use express.bodyParser()

app.get '/hello', (req, res) =>
  res.send 'hello world' 

app.get '/links', (req, res) =>
  bbox = req.query.bbox.split ','
  query = "SELECT id, ST_AsText(geom) AS wkt
    FROM links WHERE geom && 'BOX(#{bbox[0]} #{bbox[1]},#{bbox[2]} #{bbox[3]}'::box2d"
  client.query query, (err, result) ->
    res.send result.rows
  
app.post '/links', (req, res) =>
  client.query "SELECT createlink($1)", [req.body.wkt]
  res.send 'ok'

app.listen 3000

