'use strict';

var express 		= require('express');
var app 				= express();
var logger 			= require('morgan');
var bodyParser 	= require('body-parser');
var passport 		= require("passport");
var route 			= require("./routes")(passport);
var readFiles 	= require("./common/readFiles");

app.set(function () {
    app.use(express.bodyParser({ keepExtensions: true, uploadDir: '/tmp' }));
});
app.use(bodyParser.json({limit: '1mb'}));
app.use(bodyParser.urlencoded({            //此项必须在 bodyParser.json 下面,为参数编码
  extended: true
}));

app.use(express.static('bin'));
app.set('views', './src/jade');
app.set('view engine', 'jade');


app.use(logger("dev"));

app.use(require('connect-livereload')({
    port: 35729
}));

readFiles.getFileList("./routes/routeComponents", function(file) {
	route = require(file.path)(route);
});

app.use(route);

app.disable('etag');

app.listen(3000, function() {
    console.log('Server listening on port 3000');
});
