 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var MovieSchema = new Schema({
	url 			: {type: String},
	des 			: {type: String},
	score 			: {type: Number},
	movie_name 		: {type: String},
	type 			: {type: Number},
	release_time 	: {type: Date},
	duration_time 	: {type: Number}
});


mongoose.model('Movie', MovieSchema);
