var a = {
	user_name : "502442134",
	password: "scau19950316",
	email: "502442134@qq.com",
	phone_num: 18819473259
};
util.ajax({
	url: "/test/tx2",
	type:"POST",
	data: JSON.stringify(a)
});