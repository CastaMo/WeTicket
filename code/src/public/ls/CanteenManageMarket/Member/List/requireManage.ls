require-manage = let

	[	get-JSON,	ajax,	deep-copy] 		= 
		[	util.get-JSON, 	util.ajax,	util.deep-copy]

	_all-require-name = [
		'modify',		'recharge'
	]

	_all-require-URL = {
		'modify'		:		'/Membership/Card/Setexp'
		'recharge'		:		'/Membership/Card/Charge'
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
		"modify"		:		(ajax-object,data)-> ajax-object.url += "/#{data.user-id}"
		"recharge"		:		(ajax-object,data)-> ajax-object.url += "/#{data.user-id}"
	}

	_set-header = {}

	_get-require-data-str = {
		"modify"		:		(data)-> return "#{data.JSON}"
		"recharge"		:		(data)-> return "#{data.JSON}"
	}

	_normal-handle = (name, result_, callback)->
		result = get-JSON result_
		message = result.message
		if message is "success" then callback?(result)
		else if message then _require-fail-callback[message]?!
		else alert "系统错误"

	_require-fail-callback = {
		"User not found"					:		-> alert "用户不存在"
		"Membership card not exists"		:		-> alert "会员不存在"
		"Need phone to charge"				:		-> alert "充值需要手机号码"
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