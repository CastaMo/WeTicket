 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var TicketSchema = new Schema({
	cinema_name 	: {type: String},
	movie_name 		: {type: String},
	hail_number 	: {type: Number},
	seat_coordinate : {type: Array},
	price 			: {type: Number},
	des 			: {type: String},
	time 			: {type: String},
	user_id 		: {type: ObjectId}
});

mongoose.model('Ticket', TicketSchema);
