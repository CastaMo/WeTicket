'use strict';

var express 		= require('express');
var app 			= express();
var logger 			= require('morgan');
var bodyParser 		= require('body-parser');
var cookieParser 	= require('cookie-parser');
var passport 		= require("passport");
var route 			= require("./routes")(passport);
var config 			= require("./config");

app.set(function () {
    app.use(express.bodyParser({ keepExtensions: true, uploadDir: '/tmp' }));
});
app.use(bodyParser.json({limit: '1mb'}));
app.use(bodyParser.urlencoded({            //此项必须在 bodyParser.json 下面,为参数编码
  extended: true
}));

app.use(cookieParser(config.session_secret));

app.use(express.static('bin'));
app.set('views', './src/jade');
app.set('view engine', 'jade');


app.use(logger("dev"));

app.use(require('connect-livereload')({
    port: 35729
}));


app.use(route);

app.disable('etag');

app.listen(3000, function() {
    console.log('Server listening on port 3000');
});
