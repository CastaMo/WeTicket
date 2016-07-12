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

var getAllUsers = function(callback) {
	User.find(function(err, users) {
		if (err) {
			return callback(err);
		}
		return callback(null, users);
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
	getUserByUserName(options.user_name, function(err, user) {
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

var updatePassword = function(options, callback) {
	getUserByUserName(options.user_name, function(err, user) {
		if (err) {
			return callback(err);
		}
		if (user.password !== options.old_password) {
			return callback("Wrong password");
		}
		user.password = options.password;
		user.save(callback);
	});
}

var updateProfile = function(options, callback) {
	getUserByUserName(options.user_name, function(err, user) {
		if (err) {
			return callback(err);
		}
		if (options.email) {
			user.email = options.email;
		}
		if (options.phone_number) {
			user.phone_number = options.phone_number;
		}
		user.save(callback);
	});
}

module.exports = {
	getAllUsers 		: 	getAllUsers,
	getUserById 		: 	getUserById,
	getUserByUserName 	: 	getUserByUserName,
	auth 				: 	auth,
	newAndSave 			: 	newAndSave,
	updatePassword 		: 	updatePassword,
	updateProfile 		: 	updateProfile
};