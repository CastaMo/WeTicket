let win = window, doc = document
	[getJSON] = [util.getJSON]

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-module!
	}

	_main-init = (result)->
		_init-callback["success"]?(result)

	_init-all-module = !->
		page		= require "./pageManage.js";			page.initial!
		main		= require "./mainManage.js";		 	main.initial!
		modify		= require "./modifyManage.js";			modify.initial!
		recharge	= require "./rechargeManage.js";		recharge.initial!
		require_    = require "./requireManage.js";			require_.initial!

	_main-init!
