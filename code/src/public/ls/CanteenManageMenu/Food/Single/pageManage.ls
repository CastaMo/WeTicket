page-manage = let
	_state = null

	$("\#Food-sub-menu").addClass "choose"
	$("\#food-nav li\#Single").addClass "choose"

	_main-dom 			= $ "\#food-single-main"
	_new-dom 			= $ "\#food-single-new"
	_edit-dom 			= $ "\#food-single-edit"
	_all-toggle-dom 	= [_main-dom, _new-dom, _edit-dom]

	_full-cover-dom 	= $ "\#full-cover"
	_move-dom 			= _full-cover-dom.find ".move-field"
	_copy-dom 			= _full-cover-dom.find ".copy-field"
	_property-dom 		= _full-cover-dom.find ".property-field"
	_loading-dom 		= _full-cover-dom.find ".loading-field"
	_all-cover-dom 		= [_move-dom, _copy-dom, _property-dom, _loading-dom]
	
	_cover-state = 0

	_unshow-all-toggle-dom-except-given = (dom_)->
		for dom in _all-toggle-dom when dom isnt dom_
			dom.fade-out 100

	_unshow-all-cover-dom = !->
		for dom in _all-cover-dom
			dom.add-class "hide"

	_toggle-page-callback = {
		"main"		: 		let
			->
				set-timeout (-> _main-dom.fade-in 100), 100
				_unshow-all-toggle-dom-except-given _main-dom
		"new"		: 		let
			->
				set-timeout (-> _new-dom.fade-in 100), 100
				_unshow-all-toggle-dom-except-given _new-dom

		"edit"		: 		let
			->
				set-timeout (-> _edit-dom.fade-in 100), 100
				_unshow-all-toggle-dom-except-given _edit-dom
	}

	_cover-page-callback = {
		"move" 		:		let
			->
				_cover-state := 1
				_unshow-all-cover-dom!
				_move-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"copy" 		:		let
			->
				_cover-state := 2
				_unshow-all-cover-dom!
				_copy-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"property" : 		let
			->
				_cover-state := 3
				_unshow-all-cover-dom!
				_property-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
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
