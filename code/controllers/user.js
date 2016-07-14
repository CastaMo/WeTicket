var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	authMiddleWare 	= require('../middlewares/auth'),
	parseCookie 	= require("../common/parseCookie"),
	User			= dao.User;
	Cinema 			= dao.Cinema;
	Movie	 		= dao.Movie;


var getAllUsers = function(req, res, next) {
	User.getAllUsers(function(err, users) {
		res.json(users);
	});
}

var createUser = function(req, res, next) {
	User.newAndSave(req.body, function(err, user) {
		if (err) {
			return res.json({
				message: err
			});
		}
		authMiddleWare.gen_session(user, res);
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
	var cookie 		= parseCookie(req.headers.cookie),
		allData 	= {},
		signal 		= 3,
		err_flag 	= false,
		ep 			= new EventProxy(),
		events 		= ['user', 'cinemas', 'movies'],
		user_name;

	ep.assign(events, function(user, cinemas, movies) {
		if (err_flag) {
			return res.render("mainpage/develop", {
				mainJSON : 	JSON.stringify({
					message : "fail"
				})
			});
		} else {
			return res.render("mainpage/develop", {
				mainJSON : 	JSON.stringify({
					message : "success",
					allData : allData
				})
			});
		}
	});

	if (user_name = cookie.user_name) {
		User.getUserByUserName(user_name, function(err, user) {
			if (err || !user) {
				res.cookie("user_name", "");
				err_flag = true;
			} else {
				allData.user = user;
			}
			ep.emit("user", user);
		});
	} else {
		ep.emit("user", null);
	}

	Cinema.getAllCinema(function(err, cinemas) {
		if (err) {
			err_flag = true;
		} else {
			allData.cinema = cinemas[0];
		}
		ep.emit("cinemas", cinemas);
	});

	Movie.getAllMovies(function(err, movies) {
		if (err) {
			err_flag = true;
		} else {
			allData.movies = movies;
		}
		ep.emit("movies", movies);
	});

}

module.exports = {
	getAllUsers 	: 	getAllUsers,
	createUser 		: 	createUser,
	updatePassword 	: 	updatePassword,
	updateProfile 	: 	updateProfile,
	login 			: 	login,
	showMain 		: 	showMain
};