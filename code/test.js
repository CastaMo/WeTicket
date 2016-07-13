var a = {
	user_name : "user",
	password: "pass",
	email: "502442134@qq.com",
	phone_number: 18819473259
};
util.ajax({
	url: "/test/tx3",
	type:"POST",
	data: JSON.stringify(a)
});



var c = {
	cinema_name : "广州金逸珠江国际影城",
	address 	: "小谷街道贝岗村中二横路1号GOGO新天地商业广场",
	scores 		: [5, 5]
}
util.ajax({
	url: "/test/tx6",
	type:"POST",
	data: JSON.stringify(c)
});