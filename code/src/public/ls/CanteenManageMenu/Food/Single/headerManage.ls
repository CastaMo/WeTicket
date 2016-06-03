main = page = require_ = null
header-manage = let

	[		deep-copy] =
		[	util.deep-copy]

	_header-containter-dom = $ "\#food-single-main .food-single-table .oper-container"
	_control-headers = {}

	_all-control-header-name = [
		'new', 			'edit', 			'move',
		'top', 			'copy', 			'show-or-hide',
		'remove'
	]

	_all-control-header-check-fn = {
		"new" 			: 		(_current-dish-id)-> return true
		"edit" 			:		(_current-dish-id)-> return _current-dish-id.length is 1
		"move" 			:		(_current-dish-id)-> return _current-dish-id.length >= 1
		"top" 			:		(_current-dish-id)-> return _current-dish-id.length >= 1
		"copy" 			:		(_current-dish-id)-> return _current-dish-id.length >= 1
		"show-or-hide" 	:		(_current-dish-id)->
			if _current-dish-id.length is 0 then return false
			_able = main.get-dish-by-id(_current-dish-id[0]).able
			for id in _current-dish-id
				if _able isnt main.get-dish-by-id(id).able then return false
			return true
		"remove" 		:		(_current-dish-id)-> return _current-dish-id.length >= 1
	}

	_special-check-callback = {
		"show-or-hide" 	:		(_current-dish-id)!->
			if main.get-dish-by-id(_current-dish-id[0]).able
				@dom.find("p").html("售罄"); @able = true
			else
				@dom.find("p").html("显示"); @able = false
	}

	_all-control-header-click-event = {
		"new" 			:		!-> main.toggle-to-new!
		"edit" 			:		!-> main.toggle-to-edit-for-current-choose-dish!
		"move" 			:		!-> page.cover-page "move"
		"top" 			:		!->
			page.cover-page "loading"
			require_.get("top").require {
				data 		:		{
					JSON 	: 		JSON.stringify(main.get-current-dishes-id!)
				}
				success 	:		(result)!-> main.top-for-current-choose-dishes!
				always 		:		!-> page.cover-page "exit"
			}
		"copy" 			:		!-> page.cover-page "copy"
		"show-or-hide" 	:		!->
			if @able then flag = 0
			else flag = 1
			page.cover-page "loading"
			require_.get("able").require {
				data 		:		{
					JSON 	:		JSON.stringify(main.get-current-dishes-id!)
					flag 	: 		flag
				}
				success 	:		(result)!~> main.change-able-for-current-choose-dishes-by-given !@able
				always 		:		!-> page.cover-page "exit"
			}
		"remove" 		:		!-> if confirm "确定要删除餐品吗?(此操作无法恢复)"
			page.cover-page "loading"
			require_.get("remove").require {
				data 		: 		{
					JSON 	:		JSON.stringify(main.get-current-dishes-id!)
				}
				success 	: 		(result)!-> main.remove-for-current-choose-dishes!
				always 		:		!-> page.cover-page "exit"
			}
	}

	_init-depend-module = !->
		main 		:= 	require "./mainManage.js"
		page 		:= 	require "./pageManage.js"
		require_ 	:= 	require "./requireManage.js"

	_init-all-control-header = !->
		for name in _all-control-header-name
			control-header = new ControlHeader {
				name 	:	name
			}

	class ControlHeader

		(options)!->
			deep-copy options, @
			@init!
			_control-headers[@name] = @

		init: !->
			@init-prepare!
			@init-dom!
			@init-fn!
			@init-all-event!

		init-prepare: !-> @is-able = false

		init-dom: !-> @dom = _header-containter-dom.find("\##{@name}")

		init-fn: !->
			@check-fn  					= _all-control-header-check-fn[@name]
			@special-check-callback  	= _special-check-callback[@name]
			@valid-callback 			= !-> @dom.remove-class "disabled"; 	@is-able = true
			@invalid-callback 			= !-> @dom.add-class "disabled"; 	@is-able = false
			@click-event 				= _all-control-header-click-event[@name]

		init-all-event: !-> @dom.click !~> if @is-able then @click-event!

	check-all-control-headers-by-current-dish-id: (_current-dish-id)!->
		for name, control-header of _control-headers
			if control-header.check-fn _current-dish-id then control-header.valid-callback!; 	control-header.special-check-callback?(_current-dish-id)
			else control-header.invalid-callback!

	initial: !->
		_init-depend-module!
		_init-all-control-header!
		@check-all-control-headers-by-current-dish-id []

module.exports = header-manage
