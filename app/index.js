// Generated by CoffeeScript 1.6.2
var app, assets, express, pg, port, stylus;

express = require('express');

stylus = require('stylus');

assets = require('connect-assets');

pg = require('pg');

app = express();

app.use(assets());

app.set('view engine', 'jade');

app.get('/', function(req, resp) {
  return resp.render('index');
});

app.get('/query/:stmt', function(req, resp) {
  var conn, res;

  conn = "tcp://postgres:postgres@localhost/postgres";
  res = 123;
  return pg.connect(conn, function(err, client, done) {
    var handle_error;

    handle_error = function(err) {
      if (!err) {
        return false;
      }
      return done(client);
    };
    return client.query(req.params.stmt, function(err, result) {
      if (err) {
        resp.send(err.toString());
        done;
      }
      resp.send(result.rows);
      return done;
    });
  });
});

port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

app.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
