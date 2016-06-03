main-manage = let
	page = null

	_modify-level-dom = $ "\#modify-level"
	_table-dom = $ "\#level-table"
	_modify-btn-dom = $ "\#modify-btn"
	_cancel-btn-dom = $ "\.canBtn"
	_finish-btn-dom = $ "\.finBtn"

	_init-all-event = !->
		_modify-btn-dom.click !->
			_table-dom.fade-out 100
			_modify-btn-dom.fade-out 100
			_modify-level-dom.fade-in 100
		_cancel-btn-dom.click !->
			_modify-level-dom.fade-out 100
			_table-dom.fade-in 100
			_modify-btn-dom.fade-in 100
		_finish-btn-dom.click !->
			_modify-level-dom.fade-out 100
			_table-dom.fade-in 100
			_modify-btn-dom.fade-in 100

	_init-depend-module = !->
		page := require "./pageManage.js"


	initial: !->
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage