 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var TicketSchema = new Schema({
	order_id 		: {type: ObjectId},
	seat_coordinate : {type: Array},
	session_id 		: {type: ObjectId},
	price 			: {type: Number}
});


mongoose.model('Ticket', TicketSchema);
