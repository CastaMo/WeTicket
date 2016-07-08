 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var CinemaSchema = new Schema({
	cinema_name 	: {type: String},
	address 		: {type: String},
	scores 			: {type: Array}
});


mongoose.model('Cinema', CinemaSchema);
