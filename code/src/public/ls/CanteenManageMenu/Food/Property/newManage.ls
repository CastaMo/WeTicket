main 		= null
page 		= null
subItem 	= null
require_ 	= null

new-manage = let

	_new-dom 						= $ "\#property-new"
	_name-input-dom 				= _new-dom.find ".name-field input"
	_remark-input-dom 				= _new-dom.find ".remark-field input"
	_property-sub-item-list-dom 	= _new-dom.find "ul.content-list"
	_add-sub-item-btn-dom		 	= _new-dom.find ".add-btn"
	_cancel-btn-dom 				= _new-dom.find ".cancel-btn"
	_save-btn-dom 					= _new-dom.find ".save-btn"

	_name 				= null
	_remark 			= null
	_content 			= []

	_new-id 			= null


	_read-from-input = !->
		_name 			:= _name-input-dom.val!
		_remark 		:= _remark-input-dom.val!
		_content 		:= subItem.get-all-property-sub-items-value!

	_reset = !->
		subItem.reset!
		_name-input-dom.val ""
		_remark-input-dom.val ""
		_name 		:= null
		_remark 	:= null
		_content 	:= []
		_new-id 	:= null

	_check-is-valid = ->
		_valid-flag = true; _err-msg = ""
		if _name.length <= 0 or _name.length > 32 then _valid-flag = false; _err-msg += "名字长度应为(1~32)\n"
		if _remark.length > 32 then _valid-flag = false; _err-msg += "备注长度应为(0~32)\n"
		for property-sub-item, i in _content
			name = property-sub-item.name
			if name.length <= 0 or name.length > 32 then _valid-flag = false; _err-msg += "第#{i+1}项的名字长度应为(1~32)\n"
			price = property-sub-item.price
			if price.length is 0 or Number(price) < 0 or Number(price) > 100000 then _valid-flag = false; _err-msg += "第#{i+1}项的价格应为(0~100000)\n"
		if not _valid-flag then alert _err-msg
		return _valid-flag

	_success-callback = !->
		main.add-property {
			id 			:		_new-id
			name 		:		_name
			content 	: 		_content
			belong_to 	:		[]
			remark 		:		_remark
		}
		page.toggle-page "main"
		_reset!

	_get-upload-JSON-for-add = ->
		return JSON.stringify {
			name  		:		_name
			remark 		:		_remark
			type 		:		"property"
			content 	:		_content
		}

	_cancel-btn-click-event = !->
		page.toggle-page "main"
		_reset!

	_save-btn-click-event = !->
		_read-from-input!
		if not _check-is-valid! then return
		require_.get("add").require {
			data 		:		{
				JSON 	:		_get-upload-JSON-for-add!
			}
			success 	: 		(result)!-> _new-id := result.id; _success-callback!
		}

	_add-sub-item-btn-click-event = !->
		subItem.add-proprety-sub-item!

	_init-all-event = !->
		_cancel-btn-dom.click !-> _cancel-btn-click-event!

		_save-btn-dom.click !-> _save-btn-click-event!

		_add-sub-item-btn-dom.click !-> _add-sub-item-btn-click-event!

	_init-depend-module = !->
		main 		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"
		subItem 	:= require "./subItemManage.js"
		require_ 	:= require "./requireManage.js"

	initial: !->
		_init-depend-module!
		_init-all-event!

	toggle-callback: !->
		_reset!
		subItem.set-current-property-sub-item-dom-by-target {
			property-sub-item-list-dom 		: 	_property-sub-item-list-dom
		}

module.exports = new-manage