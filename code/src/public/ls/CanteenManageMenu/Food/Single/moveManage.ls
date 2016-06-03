main = page = require_ = null
move-manage = let
	[ 		deep-copy] = 
		[	util.deep-copy]

	_move-dom 			= $ "\#full-cover .move-field"
	_select-dom 		= _move-dom.find "select"
	_close-dom 			= _move-dom.find ".close-btn"
	_cancel-dom 		= _move-dom.find ".cancel-btn"
	_confirm-dom 		= _move-dom.find ".confirm-btn"
	_category-name 		= null

	_get-upload-JSON-for-copy = (current-dishes-id, new-category-id)->
		request-object = {}
		for id in current-dishes-id
			request-object[id] = new-category-id
		return JSON.stringify request-object

	_success-callback = !->
		page.cover-page "exit"
		main.move-for-current-choose-dishes-by-given _category-name

	_init-depend-module = !->
		main 		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"
		require_ 	:= require "./requireManage.js"

	_init-all-event = !->
		_close-dom.click !-> page.cover-page "exit"

		_cancel-dom.click !-> page.cover-page "exit"

		_confirm-dom.click !-> _confirm-btn-click-event!

	_confirm-btn-click-event = !->
		_category-name := _select-dom.val!
		if main.is-equal-for-category _category-name then alert "请选择其他品类"; return
		current-dishes-id = main.get-current-dishes-id!; new-category-id = main.get-category-id-by-name _category-name
		page.cover-page "loading"
		require_.get("move").require {
			data 		:		{
				JSON 	:		_get-upload-JSON-for-copy current-dishes-id, new-category-id
			}
			success 	: 		(result)!-> _success-callback!
			always 		:		!-> page.cover-page "exit"
		}

	initial: !->
		_init-depend-module!
		_init-all-event!

module.exports = move-manage