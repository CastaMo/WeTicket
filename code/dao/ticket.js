var EventProxy 	= require("eventproxy"),
	models 		= require("../models"),
	Ticket 		= models.Ticket;

var getTicketById = function(id, callback) {
	Ticket.findOne({_id:id}, function(err, ticket) {
		if (err) {
			return callback(err, ticket);
		}
		return callback(null, ticket);
	});
}


var newAndSave = function(options, callback) {
	var ticket 				= new Ticket();

	ticket.hail_number 		= options.hail_number;
	ticket.seat_coordinate 	= options.seat_coordinate;
	ticket.price 			= options.price;
	ticket.des 				= options.des;
	ticket.time 			= options.time;
	ticket.cinema_name 		= options.cinema_name;
	ticket.user_id 			= options.user_id;

	ticket.save(callback);
}

var removeById = function(id, callback) {
	Ticket.remove({_id: id}, function(err) {
		if (err) {
			return callback(err);
		}
		return callback(null);
	});
}

var getAllTicketsByUserId = function(user_id, callback) {
	Ticket.find({user_id:user_id}, function(err, tickets) {
		if (err) {
			return callback(err);
		}
		return callback(null, tickets);
	});
}


module.exports = {
	getTicketById 	 		: 	getTicketById,
	newAndSave 				: 	newAndSave,
	removeById 				: 	removeById,
	getAllTicketsByUserId 	: 	getAllTicketsByUserId
};
