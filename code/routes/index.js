'use strict';

var express 	= require('express'),
	app 		= express(),
	router 		= express.Router(),
	User 		= require("../controllers/user"),
	Cinema 		= require("../controllers/cinema"),
	Movie 		= require("../controllers/movie"),
	Ticket 		= require("../controllers/ticket"),
	parseCookie = require("../common/parseCookie");

module.exports = function(passport) {

	router.get('/', function(req, res) {
		res.redirect("/index");
	});

	router.get('/index', User.showMain);

	router.post('/User/Signup', User.createUser);

	router.post('/User/Login', User.login);

	router.post('/User/Logout', User.logout);

	router.post('/User/Update/Profile', User.updateProfile);

	router.post('/User/Update/Password', User.updatePassword);

	router.post('/Ticket/Add', Ticket.createTicket);

	router.post('/Ticket/Remove', Ticket.removeTicket);

	return router;
};
