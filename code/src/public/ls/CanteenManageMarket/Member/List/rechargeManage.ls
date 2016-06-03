main = page = null
recharge-manage = let

	_recharge-dom   = $ "\#full-cover .recharge-field"
	_close-dom 		= _recharge-dom.find ".close-btn"
	_cancel-dom 	= _recharge-dom.find ".cancel-btn"
	_save-dom 		= _recharge-dom.find ".confirm-btn"

	_init-depend-module = !->
		main 		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"

	_init-all-event = !->
		_close-dom.click !-> page.cover-page "exit"

		_cancel-dom.click !-> page.cover-page "exit"

		_save-dom.click !-> _save-btn-click-event!

	_save-btn-click-event = !->
		page.cover-page "exit"


	initial: !->
		_init-depend-module!
		_init-all-event!

module.exports = recharge-manage