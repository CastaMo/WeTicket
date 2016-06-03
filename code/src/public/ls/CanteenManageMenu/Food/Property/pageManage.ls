page-manage = let
	_state = null

	$("\#Food-sub-menu").addClass "choose"
	$("\#food-nav li\#Property").addClass "choose"

	_main-dom = $ "\#property-main"
	_new-dom = $ "\#property-new"
	_edit-dom = $ "\#property-edit"
	_all-dom = [_main-dom, _new-dom, _edit-dom]

	_unshow-all-dom-except-given = (dom_)->
		for dom in _all-dom when dom isnt dom_
			dom.fade-out 100

	_toggle-page-callback = {
		"main"		:	 let
			->
				set-timeout (-> _main-dom.fade-in 100), 100
				_unshow-all-dom-except-given _main-dom
		"new"		:	 let
			->
				set-timeout (-> _new-dom.fade-in 100), 100
				_unshow-all-dom-except-given _new-dom

		"edit"		:	 let
			->
				set-timeout (-> _edit-dom.fade-in 100), 100
				_unshow-all-dom-except-given _edit-dom
	}


	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!

module.exports = page-manage
