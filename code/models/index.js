/**
 * @desc: models出口文件
 * @author: CastMo
 * @last-edit_date: 2016-07-08
 */

var mongoose = require('mongoose'),
	config   = require('../config.js');

mongoose.connect(config.db, function(err) {
	if (err)
		return console.log('connect to %s error', config.db, err.message);

	console.log('database connect success');
});

// models
require('./cinema.js');
require('./movie.js');
require('./order.js');
require('./session.js');
require('./ticket.js');
require('./user.js');

exports.Cinema 		= mongoose.model('Cinema');
exports.Movie 		= mongoose.model('Movie');
exports.Order 		= mongoose.model('Order');
exports.Session 	= mongoose.model('Session');
exports.Ticket 		= mongoose.model('Ticket');
exports.User 		= mongoose.model('User');

