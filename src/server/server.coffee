express = require 'express'
pg = require 'pg'

connString = "tcp://postgres:postgres@localhost/solidnet"

client = new pg.Client connString
client.connect()

app = express.createServer()

app.configure =>
  app.use express.static '/home/bjorn/code/solidnet'
  app.use express.bodyParser()

app.get '/', (req, res) =>
  res.send 'hello world' 

app.post '/links', (req, res) =>
  client.query "SELECT solidnet.createlink($1)", ["linefromtext('"+req.body+"')"]
  res.send 'ok'

app.listen 3000

