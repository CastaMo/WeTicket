let win = window, doc = document
	[getJSON] = [util.getJSON]

	_get-group-JSON = null

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result.data
			_init-all-module!
	}

	_init-all-get-JSON-func = (data)->
		_get-group-JSON := -> return data.groups


	_main-init = (result)->
		_init-callback[result.message]?(result)

	_init-all-module = !->
		page 		= require "./pageManage.js";			page.initial!
		main 		= require "./mainManage.js";		 	main.initial _get-group-JSON
		new_ 		= require "./newManage.js"; 			new_.initial!
		edit 		= require "./editManage.js"; 			edit.initial!
		subItem 	= require "./subItemManage.js"; 		subItem.initial!
		require_ 	= require "./requireManage.js"; 		require_.initial!


	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_test-is-data-ready!

