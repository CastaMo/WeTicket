#与后台相关请求
require-manage = let

	[	get-JSON,	ajax,	deep-copy] 		= 
		[	util.get-JSON, 	util.ajax,	util.deep-copy]

	_all-require-name = [
		'login',		'logout',	'register',		'add',		'delete',		'modify-password',		'modify-profile'
	]

	_all-require-URL = {
		'login'				:		'/User/Login'
		'logout'			:		'/User/Logout'
		'register'			:		'/User/Signup'
		'add'				:		'/Ticket/Add'
		'delete'			:		'/Ticket/Remove'
		'modify-password'	:		'/User/Update/Password'
		'modify-profile'	:		'/User/Update/Profile'
	}

	_requires = {}

	_default-config = {
		async	: 	true
		type	:	"POST"
	}

	_get-normal-ajax-object = (config)->
		return {
			url 		:		config.url
			type		:		config.type
			async 		:		config.async
		}

	_correct-URL = {
		"login"			:		(ajax-object,data)-> ajax-object.url += ""
		"logout"			:		(ajax-object,data)-> ajax-object.url += ""		
		"register"		:		(ajax-object,data)-> ajax-object.url += ""
		"add"			:		(ajax-object,data)-> ajax-object.url += ""
		"delete"		:		(ajax-object,data)-> ajax-object.url += ""
		"modify-profile"		:		(ajax-object,data)-> ajax-object.url += ""	
		"modify-password"		:		(ajax-object,data)-> ajax-object.url += ""
	}

	_set-header = {}

	_get-require-data-str = {
		"login"			:		(data)-> return "#{data.JSON}"
		"logout"			:		(data)-> return "#{data.JSON}"
		"register"		:		(data)-> return "#{data.JSON}"
		"add"			:		(data)-> return "#{data.JSON}"
		"delete"		:		(data)-> return "#{data.JSON}"
		"modify-password"		:		(data)-> return "#{data.JSON}"
		"modify-profile"		:		(data)-> return "#{data.JSON}"
	}

	_normal-handle = (name, result_, callback)->
		result = get-JSON result_
		message = result.message
		if message is "success" then callback?(result)
		else if message then _require-fail-callback[message]?!
		else alert "系统错误"

	_require-fail-callback = {
		"message"					:		-> alert "Invalid $value"
	}

	_require-handle = (name, config)->
		return (options)->
			ajax-object = _get-normal-ajax-object config
			ajax-object.data = _get-require-data-str[name]? options.data
			_correct-URL[name]? ajax-object, options.data
			_set-header[name]? ajax-object, options.data
			ajax-object.success = (result_)-> _normal-handle name, result_, options.callback
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