'use strict';

var express = require('express');
var app = express();
var router = express.Router();

module.exports = function(passport) {

	router.get('/', function(req, res) {
		res.send('hello world');
	});

	router.post('/test/tx1', function(req, res, next){

	});

	return router;
};
