var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	Movie 		= models.Movie;

var getMovieById = function(id, callback) {
	Movie.findOne({_id:id}, function(err, movie) {
		if (err) {
			return callback(err, movie);
		}
		return callback(null, movie);
	});
}


var newAndSave = function(options, callback) {
	var movie 			= new Movie();

	movie.url			= options.url;
	movie.des 			= options.des;
	movie.score 		= options.score;
	movie.movie_name 	= options.movie_name;
	movie.release_time 	= options.release_time;

	movie.save(callback);
}



module.exports = {
	getMovieById 	: 	getMovieById,
	newAndSave 		: 	newAndSave
};