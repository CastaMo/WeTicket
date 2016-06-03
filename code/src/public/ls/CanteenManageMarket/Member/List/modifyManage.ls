main = page = null
modify-manage = let

	_modify-dom		= $ "\#full-cover .modify-field"
	_close-dom		= _modify-dom.find ".close-btn"
	_cancel-dom		= _modify-dom.find ".cancel-btn"
	_save-dom		= _modify-dom.find ".confirm-btn"

	_init-depend-module = !->
		main		:= require "./mainManage.js"
		page		:= require "./pageManage.js"

	_init-all-event = !->
		_close-dom.click !->
			page.cover-page "exit"

		_cancel-dom.click !->
			page.cover-page "exit"

		_save-dom.click !->
			_save-btn-click-event!

	_save-btn-click-event = !->
		page.cover-page "exit"

		
	initial: !->
		_init-depend-module!
		_init-all-event!

module.exports = modify-manage