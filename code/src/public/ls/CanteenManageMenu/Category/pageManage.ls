page-manage = let
	_state = null

	$("\#Category-sub-menu").addClass "choose"

	_main-dom = $ "\#category-main"
	_new-dom = $ "\#category-new"
	_edit-dom = $ "\#category-edit"
	_all-dom = [_main-dom, _new-dom, _edit-dom]

	_full-cover-dom 	= $ "\#full-cover"
	_loading-dom 		= _full-cover-dom.find ".loading-field"
	_all-cover-dom 		= [_loading-dom]
	
	_cover-state = 0

	_unshow-all-dom-except-given = (dom_)->
		for dom in _all-dom when dom isnt dom_
			dom.fade-out 100

	_unshow-all-cover-dom = !->
		for dom in _all-cover-dom
			dom.add-class "hide"

	_toggle-page-callback = {
		"main"		:	 let
			->
				_unshow-all-dom-except-given _main-dom
				set-timeout (-> _main-dom.fade-in 100), 100
		"new"		:	 let
			->
				_unshow-all-dom-except-given _new-dom
				set-timeout (-> _new-dom.fade-in 100), 100

		"edit"		:	 let
			->
				_unshow-all-dom-except-given _edit-dom
				set-timeout (-> _edit-dom.fade-in 100), 100
	}

	_cover-page-callback = {
		"loading" 	: 		let
			->
				_cover-state := 4
				_unshow-all-cover-dom!
				_loading-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"exit" 		:		let
			->
				_cover-state := 0
				_full-cover-dom.fade-out 100, !-> if _cover-state is 0 then _unshow-all-cover-dom!

	}


	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!

	cover-page: (page)->
		_cover-page-callback[page]?!

module.exports = page-manage
