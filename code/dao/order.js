var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	Order 		= models.Order;


var newAndSave = function(options, callback) {
	var order 			= new Order();

	order.user_id 		= options.user_id;
	order.cinema_id 	= options.cinema_id;
	order.time 			= options.time;
	order.total_price 	= options.total_price;
	order.state 		= options.state;

	order.save(callback);
}

var getOrderById = function(id, callback) {
	Order.findOne({_id:id}, function(err, order) {
		if (err) {
			return callback(err, order);
		}
		return callback(null, order);
	});
}


var getAllOrderByUserId = function(userId, callback) {
	Order.find({user_id:userId}, function(err, orders) {
		if (err) {
			return callback(err);
		}
		return callback(null, orders);
	});
}

var updateStateById = function(id, state, callback) {
	getOrderById(id, function(err, order) {
		if (err) {
			return callback(err);
		}
		order.state = state;
		order.save(callback);
	});
}

var removeById = function(id, callback) {
	Order.remove({_id:id}, function(err) {
		if (err) {
			return callback(err);
		}
		return callback(null);
	});
}


module.exports = {
	newAndSave 				: 		newAndSave,
	getOrderById 			: 		getOrderById,
	getAllOrderByUserId 	: 		getAllOrderByUserId,
	updateStateById 		: 		updateStateById,
	removeById 				: 		removeById
};