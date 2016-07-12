'use strict';

var express = require('express'),
	app 	= express(),
	router 	= express.Router(),
	User 	= require("../controllers/user");

module.exports = function(passport) {

	router.get('/', function(req, res) {
		res.send('hello world');
	});

	router.post('/test/tx1', User.getAllUsers);

	router.post('/test/tx2', User.createUser);

	return router;
};
