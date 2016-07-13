var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	authMiddleWare 	= require('../middlewares/auth'),
	parseCookie 	= require("../common/parseCookie"),
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
		authMiddleWare.gen_session(req.body.user_name, res);
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
			authMiddleWare.gen_session(user, res);
			res.json({
				message 	: "success",
				user 		: user
			});
		}
	});
}

var showMain = function(req, res, next) {
	var cookie = parseCookie(req.headers.cookie),
		user_name;
	if (user_name = cookie.user_name) {
		User.getUserByUserName(user_name, function(err, user) {
			if (err || !user) {
				res.cookie("user_name", "");
				res.send("err: " + err);
			} else {
				console.log(user);
				res.render("mainpage/develop", {
					allData : JSON.stringify({
						user 	: 	user
					})
				});
			}
		});
	} else {
		res.render("mainpage/develop");
	}
}

module.exports = {
	getAllUsers 	: 	getAllUsers,
	createUser 		: 	createUser,
	updatePassword 	: 	updatePassword,
	updateProfile 	: 	updateProfile,
	login 			: 	login,
	showMain 		: 	showMain
};