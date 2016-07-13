var a = {
	user_name : "tests",
	password: "scau19950316",
	email: "502442134@qq.com",
	phone_number: 18819473259
};
util.ajax({
	url: "/test/tx4",
	type:"POST",
	data: JSON.stringify(a)
});
