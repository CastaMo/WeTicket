 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var SessionSchema = new Schema({
	cinema_id 		: {type: ObjectId},
	movie_name 		: {type: String},
	start_time 		: {type: Date},
	end_time 		: {type: Date},
	price 			: {type: Number}
});


mongoose.model('Session', SessionSchema);
