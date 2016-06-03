page-manage = let
	main = null
	$("\#Card-sub-menu").addClass "choose"
	$("\#Coupon-sub-menu").addClass "choose"
	$("\#Coupon-nav li\#Basic").addClass "choose"
	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage