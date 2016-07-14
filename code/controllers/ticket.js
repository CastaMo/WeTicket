var EventProxy 		= require("eventproxy"),
	dao 			= require("../dao"),
	Ticket			= dao.Ticket;


var createTicket = function(req, res, next) {
	Ticket.newAndSave(req.body, function(err) {
		var msg = err || "success";
		res.json({
			message : msg
		});
	});
}

var removeTicket = function(req, res, next) {
	var id = req.body.id;
	Ticket.removeById(id, function(err) {
		var msg = err || "success";
		res.json({
			message : msg
		});
	});
}


module.exports = {
	createTicket 		: 		createTicket,
	removeTicket 		: 		removeTicket
};

