page-manage = let

	_main-dom = $ "\#mainpage-content"
	_cover-dom = $ "\#cover"
	_log-dom = $ "\#log"
	_purchase-dom = $ "\#purchase"
	_person-dom = $ "\#person"
	_personal-dom = $ "\#personal"
	_detail-dom = $ "\#detail"
	_step1-dom = $ "\.choose-season"
	_step2-dom = $ "\.choose-seat"
	_step3-login-dom = $ "\.login-purchase"
	_step3-unlogin-dom = $ "\.unlogin-purchase"
	_step4-dom = $ "\.ticket-field"
	_register-dom = $ "\.register-field"
	_login-dom = $ "\.login-field"
	_all-id-dom = [_purchase-dom, _main-dom, _cover-dom, _log-dom, _person-dom, _personal-dom, _detail-dom]
	_all-class-dom = [_step1-dom, _step2-dom, _step3-login-dom, _step3-unlogin-dom, _step4-dom, _register-dom, _login-dom]
	_all-close-dom = [_log-dom, _cover-dom, _personal-dom, _step1-dom, _step2-dom, _step3-login-dom, _step3-unlogin-dom, _step4-dom, _register-dom, _login-dom]
	_all-step-dom = [_step1-dom, _step2-dom, _step3-login-dom, _step3-unlogin-dom, _step4-dom]
	_unshow-all-dom = !->
		for dom in _all-id-dom
			dom.fade-out 200
		for dom in _all-class-dom
			dom.fade-out 200

	_unshow-close-dom = !->
		for dom in _all-close-dom
			dom.fade-out 200

	_unshow-step-dom = !->
		for dom in _all-step-dom
			dom.fade-out 200

	_toggle-page-callback = {
		"main"			:		let
			->
				_unshow-all-dom!
				_main-dom.fade-in 200
		"login"		:		let
			->
				_unshow-all-dom!
				_main-dom.fade-in 200
				_log-dom.fade-in 200
				_cover-dom.fade-in 200
				_login-dom.fade-in 200
		"register"		:		let
			->
				_unshow-all-dom!
				_main-dom.fade-in 200
				_log-dom.fade-in 200
				_cover-dom.fade-in 200
				_register-dom.fade-in 200
		"detail"		:		let
			->
				_unshow-all-dom!
				_detail-dom.fade-in 200
		"step1"		:		let
			->
				_cover-dom.fade-in 200
				_purchase-dom.fade-in 200
				_step1-dom.fade-in 200
		"step2"		:		let
			->
				_step3-login-dom.fade-out 200
				_step3-unlogin-dom.fade-out 200
				_cover-dom.fade-in 200
				_purchase-dom.fade-in 200
				_step2-dom.fade-in 200
		"step3-login"		:		let
			->
				_unshow-step-dom!
				_cover-dom.fade-in 200
				_purchase-dom.fade-in 200
				_step3-login-dom.fade-in 200
		"step3-unlogin"		:		let
			->
				_cover-dom.fade-in 200
				_purchase-dom.fade-in 200
				_step3-unlogin-dom.fade-in 200
		"step4"		:		let
			->
				_cover-dom.fade-in 200
				_purchase-dom.fade-in 200
				_step4-dom.fade-in 200
		"person"		:		let
			->
				_unshow-all-dom!
				_person-dom.fade-in 200
		"personal"		:		let
			->
				_cover-dom.fade-in 200
				_personal-dom.fade-in 200
		"close"		:		let
			->
				_log-dom.fade-out 200
				_purchase-dom.fade-out 200
				_unshow-close-dom!
	}

	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
