'use strict';

var express 	= require('express'),
	app 		= express(),
	router 		= express.Router(),
	User 		= require("../controllers/user"),
	parseCookie = require("../common/parseCookie");

module.exports = function(passport) {

	router.get('/', User.testCookie);

	router.post('/test/tx1', User.getAllUsers);

	router.post('/test/tx2', User.createUser);

	router.post('/test/tx3', User.login);

	router.post('/test/tx4', User.updateProfile);

	return router;
};
