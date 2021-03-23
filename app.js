var express = require('express');

var PORT;
if (process.env.PORT) {
  PORT = process.env.PORT;
} else {
  PORT = 80;
}

var app = express();
app.get('/', function (req, res) {
  res.send("Hello world");
});

app.listen(PORT);
console.log('Listening on port' + PORT);
