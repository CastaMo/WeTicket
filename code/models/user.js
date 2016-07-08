 var mongoose  = require('mongoose'),
 	 Schema    = mongoose.Schema,
 	 ObjectId  = Schema.ObjectId;

var UserSchema = new Schema({
	user_name 		: {type: String},
	password   		: {type: String},

	email      		: {type: String},
	phone_number	: {type: Number}

});


mongoose.model('User', UserSchema);
