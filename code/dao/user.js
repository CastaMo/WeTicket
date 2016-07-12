var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	User 		= models.User;

var getUserById = function(id, callback) {
	User.findOne({_id: id}, function(err, user) {
		if (err) {
			return callback(err);
		}
		return (null, user);
	});
}

var getUserByUserName = function(userName, callback) {
	User.findOne({user_name: userName}, function(err, user) {
		if (err) {
			return callback(err);
		}
		return callback(null, user);
	});
}

var auth = function(userName, password, callback) {
	getUserByUserName(userName, function(err, user) {
		if (err) {
			return callback(err);
		}
		if (user.password === password) {
			return callback(null);
		}
		return callback("Wrong password");
	});
}

var newAndSave = function(options, callback) {
	getUserByUserName(options.userName, function(err, user) {
		if (err) {
			return callback(err);
		}
		if (user) {
			return callback("UserName Already exist");
		}
		var user 			= new User();

		user.user_name 		= options.user_name;
		user.password 		= options.password;
		user.email 			= options.email;
		user.phone_number	= options.phone_number;

		user.save(callback);

	});
}


module.exports = {
	getMovieById 	: 	getMovieById,
	newAndSave 		: 	newAndSave
};