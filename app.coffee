require.paths.unshift "node_modules"

express = require 'express'
fs = require 'fs'

app = express.createServer()

# production
# static = 'http://share.underbluewaters.net/chadandjen.net/'

# dev
static = './'

# Setup HAML template handling
app.configure ->
  app.use express.static("#{__dirname}/transfer/public")
  app.use('/static', express.static(__dirname + '/static'))
  app.set 'view engine', 'haml'
  app.set 'view options', layout: false
  app.register '.haml', require('hamljs')

try
  require("#{__dirname}/transfer/photo_viewer").register app
catch error
  console.log 'could not register photo viewer'

# Favicon
app.get '/favicon.ico', (req, res) ->
  fs.readFile __dirname + '/static/favicon.ico', (err, content) ->
    res.writeHead 200, {'Content-Type': 'image/x-icon'}
    res.end content

# Main page
app.get '/:email?', (req, res) ->
  fs.readdir __dirname + '/static/photos/', (err, files) ->
    photos = (static + 'static/photos/' + file for file in files when file != 'portrait.jpg')
    res.render 'index', layout: false, photos: photos, static: static

app.listen 3000, '127.0.0.1'