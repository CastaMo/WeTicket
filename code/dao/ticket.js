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
	var ticket 				= new Movie();

	ticket.order_id 		= options.order_id;
	ticket.seat_coordinate 	= options.seat_coordinate;
	ticket.session_id 		= options.session_id;
	ticket.price 			= options.price;

	ticket.save(callback);
}

	Ticket.remove({_id: id}, function(err) {
		if (err) {
			return callback(err);
		}
		return callback(null);
	});
}


module.exports = {
	getTicketById 	 	: 	getTicketById,
	newAndSave 			: 	newAndSave,
	verificateById 		: 	verificateById
};
