page-manage = let
	main = null
	$("\#Hall-Order-sub-menu").addClass "choose"
	$("\#Hall-Order-nav li\#Basic").addClass "choose"

	_pre-dom = $ "\#previewBusiness"
	_mod-dom = $ "\#modifyBusiness"
	_select-dom = $ "\#selectBusiness"

	_toggle-page-callback = {
		"mod"		:	 let
			->
				_select-dom.fade-out 200
				_pre-dom.fade-out 200
				_mod-dom.fade-in 200

		"pre"		:	 let
			->
				_mod-dom.fade-out 200
				_pre-dom.fade-in 200
				_select-dom.fade-in 200
	}

	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
