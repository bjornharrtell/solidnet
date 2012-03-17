console.log 'server inits'

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
  bbox = req.query.bbox
  console.log 'bbox: ' + bbox
  client.query "SELECT * FROM links WHERE geom && SetSRID('BOX3D(" + bbox + ")'::box3d,-1)"
  # TODO: parse and respond...
  res.send 'ok'
  
app.post '/links', (req, res) =>
  client.query "SELECT createlink($1)", [req.body.wkt]
  res.send 'ok'

app.listen 3000

