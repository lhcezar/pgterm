express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
pg = require 'pg'

app = express()
# Add Connect Assets
app.use assets()
# Set View Engine
app.set 'view engine', 'jade'
# Get root_path return index view
app.get '/', (req, resp) -> 
  resp.render 'index'

app.get '/query/:stmt', (req, resp) ->

  conn = "tcp://postgres:postgres@localhost/postgres"
  #  client = new pg.Client(conn)

  res = 123
  pg.connect conn, (err, client, done) ->
    handle_error = (err) ->
      if not err
        return no
      done client

    client.query req.params.stmt, (err, result) ->
      if err 
        resp.send err.toString()
        done
      resp.send result.rows
      done
  #  client.connect()
  #  session = client.query req.params.stmt
  #session.on 'row', (ro, re) -> 
  #    res = re.rows
  #    re.addRow ro

  #  session.on 'end', (re) -> 
  #    console.log re.rows
  #    client.end.bind client

  #  resp.send "#{res}"


# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."
