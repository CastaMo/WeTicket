main-manage = let
	page = null
	_state = 0
	_step1-dom = $ "\#step1"
	_step2-dom = $ "\#step2"
	_step3-dom = $ "\#step3"
	_next-dom = $ "\.nextBtn"
	_last-dom = $ "\.lastBtn"
	_fin-dom = $ "\.finBtn"

	_init-all-event = !->
		_step1-dom.click !->
			page.toggle-page "step1"
			_state := 0
		_step2-dom.click !->
			page.toggle-page "step2"
			_state := 1
		_step3-dom.click !->
			page.toggle-page "step3"
			_state := 2
		_next-dom.click !->
			if _state < 2
				_state := _state + 1
			if _state == 1
				page.toggle-page "step2"
			else if _state == 2
				page.toggle-page "step3"
		_last-dom.click !->
			if _state > 0
				_state := _state - 1
			if _state == 1
				page.toggle-page "step2"
			else if _state == 0
				page.toggle-page "step1"

	_init-depend-module = !->
		page := require "./pageManage.js"

	get-state: -> return _state

	initial: !->
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage