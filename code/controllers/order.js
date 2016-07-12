var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	Order			= dao.Order;


var createOrder = function(req, res, next) {
	Order.newAndSave(req.body, function(err) {
		var msg = err || "success";
		res.json({
			message : "success"
		});
	});
}

var removeOrder = function(req, res, next) {
	var id = req.params.id;
	Order.removeById(id, function(err) {
		var msg = err || "success";
		res.json({
			message : msg
		});
	});
}



module.exports = {
	createOrder 	: 	createOrder,
	removeOrder 	: 	removeOrder
};

