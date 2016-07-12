var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	Cinema			= dao.Cinema;


var createCinema = function(req, res, next) {
	Cinema.newAndSave(req.body, function(err) {
		var msg = err || "success";
		res.json({
			message : msg
		});
		
	});
}


var getAllCinema = function(req, res, next) {
	Cinema.getAllCinema(function(err, cinemas) {
		if (err) {
			res.json({
				message: err
			});
		} else {
			res.json({
				message : "success",
				cinemas : cinemas
			});
		}
	});
}

module.exports = {
	createCinema 	: 	createCinema,
	getAllCinema 	: 	getAllCinema
};

