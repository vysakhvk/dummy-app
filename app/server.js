/**
 * Created by user on 15/2/17.
 */
var express = require('express');
var app = express();
var port = process.env.PORT || 8080;

app.listen(port);
console.log("App listening on port " + port);

app.get('/', function (req, res) {
    // use mongoose to get all todos in the database
    res.send('Tada! App is working form master.');
});
