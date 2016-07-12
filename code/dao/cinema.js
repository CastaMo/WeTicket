var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	Cinema 		= models.cinema;

var newAndSave = function(options, callback) {
	var cinema 			= new Cinema();

	cinema.cinema_name 	= options.cinema_name;
	cinema.address 		= options.address;
	cinema.scores 		= options.scores;

	cinema.save(callback);
};

var findCinemaById = function(id, callback) {
	Cinema.findOne({_id: id}, function(err, cinema) {
		if (err) {
			return callback(err);
		}
		return callback(null, cinema);
	});
};

var findAllCinema = function(callback) {
	Cinema.find(function(err, cinemas) {
		if (err) {
			return callback(err);
		}
		return callback(null, cinemas);
	});
}

var addScore = function(id, score, callback) {
	findCinemaById(id, function(err, cinema) {
		if (err) {
			return callback(err);
		}
		cinema.scores.push(score);
		cinema.save(callback);
	});
};

module.exports = {
	newAndSave 		: 		newAndSave,
	findCinemaById 	: 		findCinemaById,
	addScore 		: 		addScore
};
