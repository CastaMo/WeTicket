var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	Movie 		= models.Movie;

var getMovieById = function(id, callback) {
	Movie.findOne({_id:id}, function(err, movie) {
		if (err) {
			return callback(err);
		}
		return callback(null, movie);
	});
}

var getAllMovies = function(callback) {
	Movie.find(function(err, movies) {
		if (err) {
			return callback(err);
		}
		return callback(null, movies);
	});
}

var getMoviesByType = function(type, callback) {
	getAllMovies(function(err, movies) {
		if (err) {
			return callback(err);
		}
		var results = [];
		for (var i = 0, len = movies.length; i < len; i++) {
			var movie = movies[i];
			if (movie & type) {
				results.push(movie);
			}
		}
		return callback(null, results);
	});
}

var removeAll = function(callback) {
	Movie.remove(function(err) {
		if (err) {
			return callback(err);
		}
		return callback(null);
	});
}

var newAndSave = function(options, callback) {
	var movie 			= new Movie();

	movie.url			= options.url;
	movie.des 			= options.des;
	movie.movie_name 	= options.movie_name;
	movie.release_time 	= options.release_time;
	movie.duration_time = Number(options.duration_time);
	movie.type 			= Number(options.type);

	movie.save(callback);
}



module.exports = {
	getMovieById 	: 	getMovieById,
	getAllMovies 	: 	getAllMovies,
	getMoviesByType : 	getMoviesByType,
	newAndSave 		: 	newAndSave,
	removeAll 		: 	removeAll
};