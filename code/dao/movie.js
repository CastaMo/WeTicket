var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	User 		= require("./user");
	Movie 		= models.Movie;


exports.getMovieById = function(movieId, callback) {
	Movie.findOne({_id:id}, function(movie) {
		if (!movie) {
			return callback(null, null);
		}
		return callback(null, movie);
	});
}
