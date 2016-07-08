 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var OrderSchema = new Schema({
	user_id 		: {type: ObjectId},
	cinema_id 		: {type: ObjectId},
	time 			: {type: Date},
	total_price 	: {type: Number},
	state 			: {type: Number}
});


mongoose.model('Order', OrderSchema);
