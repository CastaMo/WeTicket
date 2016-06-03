let win = window, doc = document
	[getJSON] = [util.getJSON]

	_get-food-JSON 		= null
	_get-group-JSON 	= null

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result.data
			_init-all-module!
	}

	_init-all-get-JSON-func = (data)->
		_get-food-JSON 		:= -> return JSON.stringify(data.categories)
		_get-group-JSON 	:= -> return JSON.stringify(data.groups)


	_main-init = (result)->
		_init-callback[result.message]?(result)

	_init-all-module = !->
		image 		= require "./imageManage.js"; 			image.initial!
		page 		= require "./pageManage.js";			page.initial!
		group  		= require "./groupManage.js"; 			group.initial _get-group-JSON
		main 		= require "./mainManage.js";		 	main.initial _get-food-JSON
		header 		= require "./headerManage.js";			header.initial!
		move 		= require "./moveManage.js"; 			move.initial!
		copy 		= require "./copyManage.js"; 			copy.initial!
		new_ 		= require "./newManage.js"; 			new_.initial!
		edit  		= require "./editManage.js"; 			edit.initial!
		require_ 	= require "./requireManage.js";			require_.initial!


	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_test-is-data-ready!

