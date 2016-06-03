page-manage = let
	main = null
	$("\#Discount-sub-menu").addClass "choose"
	$("\#Member-sub-menu").addClass "choose"
	$("\#Member-nav li\#Basic").addClass "choose"
	_init-depend-module = !->
		main := require "./mainManage.js"

	_list-dom = $ "\#List"
	_full-cover-dom = $ "\#full-cover"
	_modify-dom = _full-cover-dom.find ".modify-field"
	_recharge-dom = _full-cover-dom.find ".recharge-field"
	_all-cover-dom = [_recharge-dom, _modify-dom]

	_unshow-all-cover-dom = !->
		for dom in _all-cover-dom
			dom.add-class "hide"

	_toggle-page-callback = {
		
	}

	_cover-page-callback = {
		"modify"		:		let
			->
				_unshow-all-cover-dom!
				_modify-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"recharge"		:		let
			->
				_unshow-all-cover-dom!
				_recharge-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"exit"		:		let
			->
				_full-cover-dom.fade-out 100, !-> _unshow-all-cover-dom!
	}

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!

	cover-page: (page)->
		_cover-page-callback[page]?!

module.exports = page-manage