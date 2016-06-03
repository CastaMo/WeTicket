require-manage = let

	[		get-JSON,		ajax,		deep-copy] 		= 
		[	util.get-JSON, 	util.ajax,	util.deep-copy]

	_requires = {}


	###
	#	ajax请求基本配置，无特殊情况不要改
	###
	_default-config = {
		async 	:	true
		type 	:	"POST"
	}

	###
	#	获取一个基本的ajax请求对象，主要有url、type、async的配置
	###
	_get-normal-ajax-object = (config)->
		return {
			url 		:		config.url
			type 		:		config.type
			async 		:		config.async
		}

	###
	#	请求名字(自己设)
	###
	_all-require-name = [
		'add',							'copy',
		'remove',						'top',
		'move', 						'edit',
		'able', 						'picUploadPre',
		'picUpload'
	]

	###
	#	请求名字与URL键值对(与后台进行商量)，名字需依赖于上述对象
	###
	_all-require-URL = {
		'add' 			:		'/Dish/Add'
		'copy' 			:		'/Dish/Copy'
		'remove' 		:		'/Dish/Remove'
		'top' 			:		'/Dish/Update/Top'
		'move' 			:		'/Dish/Update/Category'
		'edit' 			:		'/Dish/Update/All'
		'able' 			:		'/Dish/Update/Able'
		'picUploadPre' 	:		'/pic/upload/token/dishupdate'
		'picUpload' 	:		'http://up.qiniu.com/putb64'
	}

	###
	#	校正ajax-object的url
	###
	_correct-URL = {
		"add"			:		(ajax-object, data)-> ajax-object.url += "/#{data.category-id}"
		"edit" 			:		(ajax-object, data)-> ajax-object.url += "/#{data.dish-id}"
		"able" 			:		(ajax-object, data)-> ajax-object.url += "/#{data.flag}"
		'picUploadPre' 	:		(ajax-object, data)-> ajax-object.url += "/#{data.id}"
		'picUpload' 	:		(ajax-object, data)-> ajax-object.url += "/#{data.fsize}/key/#{data.key}"
	}


	###
	#	按照需要设定header
	###
	_set-header = {
		"picUpload" 		:		(ajax-object, data)-> ajax-object.header =  {
			"Content-Type" 		:		"application/octet-stream"
			"Authorization" 	:		"UpToken #{data.token}"
		}
	}


	###
	#	ajax请求对象对应的数据请求属性，以键值对Object呈现于此
	###
	_get-require-data-str = {
		"add" 			:		(data)-> return "#{data.JSON}"
		"copy" 			:		(data)-> return "#{data.JSON}"
		"remove" 		:		(data)-> return "#{data.JSON}"
		"top" 			: 		(data)-> return "#{data.JSON}"
		"move" 			:		(data)-> return "#{data.JSON}"
		"edit" 			:		(data)-> return "#{data.JSON}"
		"able" 			:		(data)-> return "#{data.JSON}"
		"picUploadPre" 	:		(data)-> return ""
		"picUpload" 	:		(data)-> return "#{data.url}"

	}

	###
	#	在请求状态码为200且返回的message属性不为success时的处理方法
	###
	_require-fail-callback = {
		"Activity not found" 					:		-> alert "活动不存在"
		"Category not found" 					:		-> alert "品类不存在"
		"Dish not found" 						:		-> alert "餐品不存在"
		"Dinner not found" 						:		-> alert "餐厅不存在"
		"Conflict property name" 				:		-> alert "属性名冲突"
		"Membership card not exists" 			:		-> alert "会员卡不存在"
		"Not enough money" 						:		-> alert "会员卡余额不足"
		"Printer not found" 					:		-> alert "打印机不存在"
		"Conflict feie printer" 				:		-> alert "某台飞鹅打印机在餐厅添加了两次，且为相同的打印模式"

		"Invalid template type" 				:		-> alert "（二维码导出时）模板类型不存在"
		"Invalid config" 						:		-> alert "（二维码导出时）配置不合法"
		"Invalid QR" 							:		-> alert "（前台扫码支付时）非法的二维码"

		"Table not found" 						:		-> alert "桌位不存在"
		"Used phone" 							: 		-> alert "（餐厅注册时）手机号已被使用"
		"Already has other phone"				:		-> alert "已经绑定了其他手机号"
		"User not found" 						:		-> alert "用户不存在"
		"Is not waiter of any dinner" 			:		-> alert "用户不是任何餐厅的服务员"
		"Already is waiter of current dinner" 	:		-> alert "（添加服务员时）用户已经是当前餐厅的服务员"
		"Already is waiter of another dinner" 	:		-> alert "（添加服务员时）用户已经是其他餐厅的服务员"

		"Invalid Ali QR URL" 					:		-> alert "非法的支付宝支付码"
		"Alipay qrcode not found" 				:		-> alert "支付宝支付码不存在"
	}

	###
	#	在状态码为200，即请求成功返回时的处理
	#	@{param}	name: 		请求对象的名字
	#	@{param}	result_:	返回值，即ResponseText
	#	@{param}	success:	当返回的message为success时执行的回调函数
	###
	_normal-handle = (name, result_, success)->
		result = get-JSON result_
		message = result.message
		if message is "success" then success?(result)
		else if message then _require-fail-callback[message]?!
		else alert "系统错误"


	###
	#	用于获取每个请求对象的require函数方法
	#	@param	{String}	name:		请求对象的名字
	#	@param	{Object}	config:		请求的基本配置
	#	@return	{Fn}					执行ajax请求，需要依赖于上面的函数方法
	###
	_require-handle = (name, config)->
		return (options)->
			ajax-object = _get-normal-ajax-object config
			ajax-object.data = _get-require-data-str[name]? options.data
			_correct-URL[name]? ajax-object, options.data
			_set-header[name]? ajax-object, options.data
			ajax-object.success = (result_)-> _normal-handle name, result_, options.success
			ajax-object.always = options.always
			ajax ajax-object


	class Require

		(options)->
			deep-copy options, @
			@init()
			_requires[@name] = @

		init: ->
			@init-require!

		init-require: ->
			config = {}
			deep-copy _default-config, config
			config.url = @url
			@require = _require-handle @name, config

	_init-all-require = ->
		for name, i in _all-require-name
			require = new Require {
				name 		:		name
				url 		:		_all-require-URL[name]
			}


	get: (name)-> return _requires[name]

	initial: ->
		_init-all-require!
module.exports = require-manage
