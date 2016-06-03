page-manage = let
	main = null
	$("\#Discount-sub-menu").addClass "choose"
	$("\#Member-sub-menu").addClass "choose"
	$("\#Member-nav li\#Level").addClass "choose"
	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage