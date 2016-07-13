module.exports = function(cookie) {
	var cookies ={};
	if (!cookie) {
		return cookies;
	}
	var list = cookie.split(';');
	for(var i = 0, len = list.length; i < len; i++){
		var pair = list[i].split('=');
		cookies[pair[0].trim()] = pair[1];
	}
	return cookies;
}