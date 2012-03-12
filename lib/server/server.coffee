express = require 'express'
app = express.createServer()

app.configure =>
  app.use(express.static('/home/bjorn/code/solidnet'))

app.get '/', (req, res) =>
  res.send 'hello world' 

app.listen 3000

