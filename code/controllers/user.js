var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	User			= dao.User;


var getAllUsers = function(req, res, next) {
	User.getAllUsers(function(err, users) {
		res.json(users);
	});
}

var createUser = function(req, res, next) {
	User.newAndSave(req.body, function(err) {
		if (err) {
			return res.json({
				message: err
			});
		}
		return res.json({
			message: "success"
		});
	});
}

var updatePassword = function(req, res, next) {
	User.updatePassword(req.body, function(err) {
		var msg = "";
		if (err === "Wrong password") {
			msg = err;
		} else {
			msg = "success";
		}
		res.json({
			message: msg
		});
	});
}

var updateProfile = function(req, res, next) {
	User.updateProfile(req.body, function(err) {
		var msg = err || "success";
		res.json({
			message : msg
		});
	});
}

var login = function(req, res, next) {
	var user_name 	= req.body.user_name,
		password 	= req.body.password;
	User.auth(user_name, password, function(err, user) {
		if (err) {
			res.json({
				message 	: err
			});
		} else {
			res.json({
				message 	: "success",
				user 		: user
			});
		}
	});
}

module.exports = {
	getAllUsers 	: 	getAllUsers,
	createUser 		: 	createUser,
	updatePassword 	: 	updatePassword,
	updateProfile 	: 	updateProfile
	login 			: 	login
};