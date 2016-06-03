main-manage = let
	page = null

	_apply-dom = $ $ "\.apply"

	_init-all-event = !->
		_apply-dom.click !->
			if $(this).hasClass("true")
				$(this).removeClass "true"
				$(this).addClass "false"
			else if $(this).hasClass("false")
				$(this).removeClass "false"
				$(this).addClass "true"

	_init-depend-module = !->
		page := require "./pageManage.js"


	initial: !->
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage