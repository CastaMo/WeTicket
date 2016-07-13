var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	Movie			= dao.Movie;


var createMoive = function(req, res, next) {
	Movie.newAndSave(req.body, function(err) {
		var msg = err || "success";
		res.json({
			message : msg
		});
	});
}

var getAllMovies = function(req, res, next) {
	Movie.getAllMovies(function(err, movies) {
		if (err) {
			res.json({
				message : err
			});
		} else {
			res.json({
				message : "success",
				movies 	: movies
			});
		}
	});
}

var getMoviesByType = function(req, res, next) {
	var type = req.body.type;
	Movie.getMoviesByType(type, function(err, movies) {
		if (err) {
			res.json({
				message: err
			});
		} else {
			res.json({
				message : "success",
				movies 	: movies
			});
		}
	});
}


module.exports = {
	createMoive 	: 	createMoive,
	getAllMovies 	: 	getAllMovies,
	getMoviesByType : 	getMoviesByType
};

