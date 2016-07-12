 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var MovieSchema = new Schema({
	url 			: {type: String},
	des 			: {type: String},
	score 			: {type: Number},
	movie_name 		: {type: String},
	type 			: {type: String},
	release_time 	: {type: Date}
});


mongoose.model('Movie', MovieSchema);
