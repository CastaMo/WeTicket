var config 		= require('../config');
var eventproxy 	= require('eventproxy');
var config     	= require('../config');

function gen_session(user, res) {
    var user_name = user.user_name;
    var opts = {
        maxAge 		: 1000 * 60 * 60 * 24 * 30,
        httpOnly 	: true
    };

    res.cookie("user_name", user_name, opts); //cookie 有效期30天    
}

exports.gen_session = gen_session;