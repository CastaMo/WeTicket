let win = window, doc = document
	[getJSON] = [util.getJSON]

	_get-food-JSON = null

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result.data
			_init-all-module!
	}

	_init-all-get-JSON-func = (data)->
		_get-food-JSON := -> return JSON.stringify(data.dish)


	_main-init = (result)->
		_init-callback[result.message]?(result)

	_init-all-module = !->
		page = require "./pageManage.js";			page.initial!
		main = require "./mainManage.js";		 	main.initial _get-food-JSON


	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_test-is-data-ready!
