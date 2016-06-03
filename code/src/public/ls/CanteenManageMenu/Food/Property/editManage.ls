main 		= null
page 		= null
subItem 	= null
require_ 	= null

edit-manage = let

	[		deep-copy] =
		[	util.deep-copy]

	_edit-dom 						= $ "\#property-edit"
	_name-input-dom 				= _edit-dom.find ".name-field input"
	_remark-input-dom 				= _edit-dom.find ".remark-field input"
	_property-sub-item-list-dom 	= _edit-dom.find "ul.content-list"
	_add-sub-item-btn-dom		 	= _edit-dom.find ".add-btn"
	_cancel-btn-dom 				= _edit-dom.find ".cancel-btn"
	_save-btn-dom 					= _edit-dom.find ".save-btn"

	_name 				= null
	_remark 			= null
	_content 			= []

	_current-property 	= null


	_read-from-input = !->
		_name 			:= _name-input-dom.val!
		_remark 		:= _remark-input-dom.val!
		_content 		:= subItem.get-all-property-sub-items-value!

	_read-from-current-property = !->
		_name-input-dom.val _current-property.name
		_remark-input-dom.val _current-property.remark
		_content := []
		deep-copy _current-property.content, _content

	_reset = !->
		subItem.reset!
		_name-input-dom.val ""
		_remark-input-dom.val ""
		_name 		:= null
		_remark 	:= null
		_content 	:= []

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
		main.edit-property {
			name 		:		_name
			content 	: 		_content
			belong_to 	:		_current-property.belong-to
			remark 		:		_remark
		}, _current-property.id
		page.toggle-page "main"
		_reset!

	_get-upload-JSON-for-edit = ->
		return JSON.stringify {
			name  		:		_name
			remark 		:		_remark
			content 	:		_content
		}

	_cancel-btn-click-event = !->
		page.toggle-page "main"
		_reset!

	_save-btn-click-event = !->
		_read-from-input!
		if not _check-is-valid! then return
		require_.get("edit").require {
			data 				:		{
				JSON 			:		_get-upload-JSON-for-edit!
				property-id 	: 		_current-property.id
			}
			success 			: 		(result)!-> _success-callback!
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

	toggle-callback: (property)!->
		_reset!
		_current-property := property
		_read-from-current-property!
		subItem.set-current-property-sub-item-dom-by-target {
			property-sub-item-list-dom 		: 	_property-sub-item-list-dom
			content 						:	_content
		}

module.exports = edit-manage