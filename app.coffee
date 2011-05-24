require.paths.unshift "node_modules"

express = require 'express'
fs = require 'fs'

app = express.createServer()

# production
static = 'http://share.underbluewaters.net/chadandjen.net/'

# dev
# static = ''

# Setup HAML template handling
app.configure ->
  app.use('/static', express.static(__dirname + '/static'))
  app.set 'view engine', 'haml'
  app.register '.haml', require('hamljs')

# Main page
app.get '/:email?', (req, res) ->
  fs.readdir __dirname + '/static/photos/', (err, files) ->
    photos = (static + 'static/photos/' + file for file in files when file != 'portrait.jpg')
    res.render 'index', layout: false, photos: photos, static: static

app.listen 3000, '127.0.0.1'