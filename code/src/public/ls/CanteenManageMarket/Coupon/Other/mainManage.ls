main-manage = let
	page = null
	_init-all-event = !->


	_init-depend-module = !->
		page := require "./pageManage.js"


	initial: !->
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage