page-manage = let
	main = null
	_state = null
	$(".config-menu-header").addClass "choose"

	_step1-dom = $ "\#step1Content"
	_step2-dom = $ "\#step2Content"
	_step3-dom = $ "\#step3Content"
	_all-step-dom = [_step1-dom, _step2-dom, _step3-dom]
	_step1-dom-btn = $ "\#step1"
	_step2-dom-btn = $ "\#step2"
	_step3-dom-btn = $ "\#step3"
	_step1-pic-dom = $ "\.step1Pic"
	_step2-pic-dom = $ "\.step2Pic"
	_step3-pic-dom = $ "\.step3Pic"
	_all-pic-dom = [_step1-pic-dom, _step2-pic-dom, _step3-pic-dom]
	_next-dom = $ "\.nextBtn"
	_last-dom = $ "\.lastBtn"
	_fin-dom = $ "\.finBtn"
	_all-btn-dom = [_last-dom, _next-dom, _fin-dom]

	_hide-all-dom = (dom_, callback)->
		for dom, i in dom_
			if i is dom_.length-1
				dom.fade-out 100, callback
			else dom.fade-out 100

	_toggle-page-callback = {
		"step1"		:	 let
			->
				_state := 0
				_hide-all-dom _all-btn-dom
				_hide-all-dom _all-pic-dom
				_hide-all-dom _all-step-dom, ->
					_step1-pic-dom.fade-in 200
					_step1-dom.fade-in 200
					_next-dom.fade-in 200
				
		"step2"		:	 let
			->
				_state := 1
				_hide-all-dom _all-btn-dom
				_hide-all-dom _all-pic-dom
				_hide-all-dom _all-step-dom, ->
					_step2-pic-dom.fade-in 200
					_step2-dom.fade-in 200
					_next-dom.fade-in 200
					_last-dom.fade-in 200

		"step3"		:	 let
			->
				_state := 2
				_hide-all-dom _all-btn-dom
				_hide-all-dom _all-pic-dom
				_hide-all-dom _all-step-dom, ->
					_step3-pic-dom.fade-in 200
					_step3-dom.fade-in 200
					_last-dom.fade-in 200
					_fin-dom.fade-in 200
	}

	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
		_init-depend-module!
		_state := main.get-state!

	get-state: -> return _state

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage