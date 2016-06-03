main = page = group = require_ = null
new-manange = let

	[		getObjectURL, 		deep-copy, 			getStrAfterFilter,
			converImgTobase64] = 
		[	util.getObjectURL, 	util.deep-copy, 	util.getStrAfterFilter,
			util.converImgTobase64]

	_new-dom  				= $ "\#food-single-new"

	###
	# 	input有关的dom对象
	###
	_c-name-dom 			= _new-dom.find "input\#c-name"
	_e-name-dom 			= _new-dom.find "input\#e-name"
	_default-price-dom 		= _new-dom.find "input\#default-price"
	_pic-input-dom 			= _new-dom.find "input\#new-pic"
	_remark-dom 			= _new-dom.find "input\#remark-tag"
	_intro-dom 				= _new-dom.find "textarea\#intro"
	_dc-type-select-dom 	= _new-dom.find "select\#select-dc-type"

	###
	#	放置图片显示的dom
	###
	_pic-display-dom 		= _new-dom.find 'label .img'

	###
	#	放置属性组子项的dom
	###
	_property-sub-item-list-dom = _new-dom.find "ul.property-sub-item-list"

	###
	#	dc-type的额外dom，用于放置dc的input dom
	###
	_dc-field-dom 			= _new-dom.find ".addtional"

	###
	#	按钮dom
	###
	_property-add-dom 		= _new-dom.find ".add-btn"
	_cancel-dom 			= _new-dom.find ".cancel-btn"
	_save-dom 				= _new-dom.find ".save-btn"

	###
	#	当前对应的品类id
	###
	_current-category-id 	= null


	###
	#	属性变量
	###
	_new-id 				= 0
	_c-name 				= null
	_e-name 				= null
	_default-price 			= null
	_src 					= null
	_remark 				= null
	_intro 					= null
	_dc-type 				= null
	_dc 					= null
	_groups 				= null
	_upload-flag 			= null

	###
	#	所有dc-type的name
	###
	_all-dc-type-name = [
		"none", 		"sale", 		"discount",
		"half", 		"limit"
	]

	###
	#	dc-type对应的dc范围以及显示的字
	###
	_dc-type-map-dc-options = {
		"sale" 			: 			{
			min 		: 			1
			max 		:			50
			word 		: 			"元"
		}
		"discount" 		:			{
			min 		:			10
			max 		:			99
			word 		:			"%"
		}
		"limit" 		:			{
			min 		:			1
			max 		:			99
			word 		:			"份"
		}
	}

	###************ operation start **********###

	_reset = !->
		_c-name-dom.val null
		_e-name-dom.val null
		_default-price-dom.val null
		_pic-input-dom.val null
		_remark-dom.val null
		_intro-dom.val null
		_dc-type-select-dom.val "无"; _dc-type-select-change-event!
		_pic-display-dom.css {"background-image" : ""}

		_c-name 				:= null
		_e-name 				:= null
		_default-price 			:= null
		_src 					:= null
		_remark 				:= null
		_intro 					:= null
		_dc-type 				:= null
		_dc 					:= null
		_groups 				:= []

		_upload-flag 			:= null

	_read-from-input = !->
		_get-dc-value = ->
			if _dc-type is "none" or _dc-type is "half" then return null
			return parse-int (_dc-field-dom.find "input").val!

		_c-name  			:= getStrAfterFilter _c-name-dom.val!
		_e-name 			:= getStrAfterFilter _e-name-dom.val!
		_default-price 		:= Number _default-price-dom.val!
		_remark 			:= getStrAfterFilter _remark-dom.val!
		_intro 				:= getStrAfterFilter _intro-dom.val!
		_dc-type 			:= getStrAfterFilter _dc-type-select-dom.val!
		_dc 				:= _get-dc-value!

	_connect-property-to-groups = !->
		group.set-current-property-sub-item-by-target {
			property-sub-item-list-dom 		: 		_property-sub-item-list-dom
			property-sub-item-array 		:		_groups
		}

	_check-is-valid = ->
		_valid-flag = true; _err-msg = ""
		if _c-name.length <= 0 or _c-name.length > 32 then _err-msg += "单品名称长度应为1~32位\n"; _valid-flag = false
		if _e-name.length > 32 then _err-msg += "英文名长度应为0~32位\n"; _valid-flag = false
		if _default-price-dom.val! is "" or _default-price < 0 or _default-price > 9999 then _err-msg += "默认价格范围应为0~9999元\n"; _valid-flag = false
		if _remark.length > 18 then _err-msg += "标签长度应为0~18位\n"; _valid-flag = false
		if _intro.length > 400 then _err-msg += "详情长度应为0~400位\n"; _valid-flag = false
		if _groups.length > 40 then _err-msg += "属性组数量应为0~40个\n"; _valid-flag = false
		if _dc
			options = _dc-type-map-dc-options[_dc-type]; if _dc < options.min or _dc > options.max then _err-msg += "优惠范围应在#{options.min}~#{options.max}之内\n"; _valid-flag = false
		if _valid-flag then return _valid-flag
		alert _err-msg; return _valid-flag

	_success-callback = !->
		main.create-dish-dish-by-given {
			able 				:		true
			default_price 		:		_default-price
			detail 				: 		_intro
			id 					:		_new-id
			name 				:		_c-name
			name2 				:		_e-name
			pic 				: 		_src
			groups 				: 		_groups
			tag 				:		_remark
			dc_type 			: 		_dc-type
			dc 					: 		_dc
		}

		page.toggle-page "main"
		_reset!

	_get-upload-JSON-for-add = ->
		return JSON.stringify {
			dc_type 	:		_dc-type
			dc 			:		_dc
			price 		:		_default-price
			name 		:		_c-name
			name2 		:		_e-name
			tag 		:		_remark
			detail 		:		_intro
			groups 		:		_groups	
			type 		:		"normal"
		}

	###************ operation end **********###




	###************ event start **********###

	_pic-input-change-event = (input)!->
		if file = input.files[0]
			if ((fsize = parse-int(file.size)) / 1024).to-fixed(2) > 4097 then alert "图片大小不能超过4M"
			else
				_upload-flag := true
				_src := getObjectURL file
				_pic-display-dom.css {"background-image":"url(#{_src})"}

	_dc-type-select-change-event = !->
		_dc-type := _dc-type-select-dom.val!
		_dc-field-dom.html ""
		if options = _dc-type-map-dc-options[_dc-type]
			_dc-field-dom.html "<input type='number' placeholder='(#{options.min}-#{options.max})' max='#{options.max}' min='#{options.min}'>
								<p>#{options.word}</p>
								<div class='clear'></div>"

	_property-add-btn-click-event = !-> page.cover-page "property"; group.set-current-property-active!

	###
	#	上传图片事件
	#	需要完成三个步骤
	#	①把将上传的图片转化为base64字符串
	#	②从服务器获取token与key
	#	③把图片(base64字符串)以及token一起上传给七牛服务器
	#	其中①和②可以并发进行(一个是调用Ajax异步API，一个是调用canvas同步API)，这里用到了信号量的思想去实现并发处理
	###
	_upload-pic-event = (callback)!->

		_base64-str = ""
		_data = {}


		_check-is-already-and-upload = !->
			if _base64-str and _data.token and _data.key
				#步骤③
				page.cover-page "loading"
				require_.get("picUpload").require {
					data 		:		{
						fsize 	:		-1
						token 	:		_data.token
						key 	:		btoa(_data.key).replace("+", "-").replace("/", "_")
						url 	:		_base64-str
					}
					success 	:		(result)->
						_src 		:= "http://static.brae.co/#{_data.key}"
						_base64-str := ""
						_data 		:= {}
						console.log "success"
						callback?!
					always 		:		!-> page.cover-page "exit"
				}

		#步骤②
		if _src
			page.cover-page "loading"
			require_.get("picUploadPre").require {
				data 		:		{
					id 		:		_new-id
				}
				success 	:		(result)->
					_data.token 	= 		result.token
					_data.key 		= 		result.key
					console.log "token ready"
					_check-is-already-and-upload!
				always 		:		!-> page.cover-page "exit"
			}

		#步骤①
		if _src then converImgTobase64 _src, (data-URL)->
			#图片base64字符串去除'data:image/png;base64,'后的字符串
			_base64-str := data-URL.substr(data-URL.index-of(";base64,") + 8)
			console.log "base64 ready"
			_check-is-already-and-upload!

	_cancel-btn-click-event = !->
		_reset!
		page.toggle-page "main"

	_save-btn-click-event = !->
		_read-from-input!
		if not _check-is-valid! then return
		if _upload-flag
			_callback = !-> _upload-pic-event !->
				_success-callback!
		else _callback = !-> _success-callback!
		page.cover-page "loading"
		require_.get("add").require {
			data 				:		{
				category-id 	:	_current-category-id
				JSON 			: 	_get-upload-JSON-for-add!
			}
			success 			: 	(result)!-> _new-id := result.id; _callback!
			always 				:	!-> page.cover-page "exit"
		}

	###************ event end **********###

	_init-all-event = !->

		_pic-input-dom.change !-> _pic-input-change-event @

		_dc-type-select-dom.change !-> _dc-type-select-change-event!

		_property-add-dom.click !-> _property-add-btn-click-event!

		_cancel-dom.click !-> _cancel-btn-click-event!

		_save-dom.click !-> _save-btn-click-event!


	_init-depend-module = !->
		main  		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"
		group 		:= require "./groupManage.js"
		require_ 	:= require "./requireManage.js"


	initial: !->
		_reset!
		_init-all-event!
		_init-depend-module!

	toggle-callback: (current-category-id)!->
		_reset!
		_current-category-id 	:= current-category-id
		_groups 				:= []
		_connect-property-to-groups!



module.exports = new-manange