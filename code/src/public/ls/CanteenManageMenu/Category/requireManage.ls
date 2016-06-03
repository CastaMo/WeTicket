require-manage = let

	[		get-JSON,		ajax,		deep-copy] 		= 
		[	util.get-JSON, 	util.ajax,	util.deep-copy]

	###
	#	请求名字(自己设)
	###
	_all-require-name = [
		'add',							'remove',
		'update',						'top',
		'picUploadPre',					'picUpload'
	]

	###
	#	请求名字与URL键值对(与后台进行商量)，名字需依赖于上述对象
	###
	_all-require-URL = {
		'add' 			:		'/Category/Add'
		'remove'		:		'/Category/Remove'
		'update' 		:		'/Category/Update/Profile'
		'top' 			:		'/Category/Update/Top'
		'picUploadPre' 	:		'/pic/upload/token/category'
		'picUpload' 	:		'http://up.qiniu.com/putb64'
	}

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
	#	校正ajax-object的url
	###
	_correct-URL = {
		"top"			:		(ajax-object, data)-> ajax-object.url += "/#{data.id}"
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
		"remove" 		:		(data)-> return "#{data.JSON}"
		"update" 		:		(data)-> return "#{data.JSON}"
		"top" 			:		(data)-> return ""
		"picUploadPre" 	:		(data)-> return ""
		"picUpload" 	:		(data)-> return "#{data.url}"

	}


	###
	#	在状态码为200，即请求成功返回时的处理
	#	@{param}	name: 		请求对象的名字
	#	@{param}	result_:	返回值，即ResponseText
	#	@{param}	callback:	当返回的message为success时执行的回调函数
	###
	_normal-handle = (name, result_, success)->
		result = get-JSON result_
		message = result.message
		if message is "success" then success?(result)
		else if message then _require-fail-callback[name][message]?!
		else alert "系统错误"


	###
	#	在请求状态码为200且返回的message属性不为success时的处理方法
	###
	_require-fail-callback = {
		"add"			:		{
			"Used name" 								:	-> alert "此品类名称已经存在"
		}
		"remove" 		:		{
			"Category not found" 						:	-> alert "品类不存在!"
			"Category not found or cannot be removed" 	:	-> alert "品类不存在或该品类无法被删除!"
		}
		"update" 		:		{
			"Used name" 								:	-> alert "此品类名称已经存在"
			"Category not found" 						:	-> alert "品类不存在!"
		}
		"top"			:		{
			"Category not found" 						:	-> alert "品类不存在!"
			"Dinner not found" 							:	-> alert "餐厅不存在!"
			"Already at top" 							:	-> alert "当前分类已在顶端"
		}
		"picUploadPre" 	:		{
			"Category not found" 						:	-> alert "品类不存在!"
		}
		"picUpload" 	:		{
			
		}
	}


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
