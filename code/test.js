var a = {
	user_name : "502442134",
	password: "502442134",
	email: "502442134@qq.com",
	phone_number: 18819473259
};
util.ajax({
	url: "/test/tx3",
	type:"POST",
	data: JSON.stringify(a)
});

var b = {
	user_name: "502442134",
	old_password: "scau19950316",
	password: "502442134"
};
util.ajax({
	url: "/test/tx5",
	type:"POST",
	data: JSON.stringify(b)
});

var c = [
	{
		a : "s",
		b : "s",
		c : "s" // 最后一个键值不要逗号
	},
	{
		a : "s",
		b : "s",
		c : "s"
	},
	{
		a : "s",
		b : "s",
		c : "s"
	} // 最后一个对象不要逗号
]