var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	Session 	= models.Session;


var newAndSave = function (options, callback) {
	var session  		= new Session();

	session.cinema_id 	= options.cinema_id;
	session.movie_name 	= options.movie_name;
	session.start_time 	= options.start_time;
	end_time 			= options.end_time;
	price 				= options.price;

	session.save(callback);
}


var getSessionById = function(id, callback) {
	Session.findOne({_id: id}, function(err, session) {
		if (err) {
			return callback(err);
		}
		return callback(null, session);
	});
}

var getSessionByCinemaId = function(cinemaId, callback) {
	Session.find({cinema_id: cinemaId}, function(err, sessions) {
		if (err) {
			return callback(err);
		}
		return callback(null, sessions);
	});
}

var removeById = function(id, callback) {
	Session.remove({_id: id}, function(err) {
		if (err) {
			return callback(err);
		}
		return callback(null);
	});
}

module.exports = {
	newAndSave 				: 		newAndSave,
	getSessionById 			: 		getSessionById,
	getSessionByCinemaId 	: 		getSessionByCinemaId,
	removeById 				: 		removeById
};
