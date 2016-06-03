page = main = require_ = null
new-manage = let
	
	[		get-Object-URL,			converImgTobase64] = 
		[	util.get-Object-URL,	util.converImgTobase64]

	_name-input-dom = $ "input\#new-name"
	_pic-input-dom = $ "input\#new-pic"
	_display-img-dom = $ "\#new-table .img-field .img"
	_cancel-btn-dom = $ "\#new-table .cancel-btn"
	_save-btn-dom = $ "\#new-table .save-btn"

	_is-wait 		= false
	_src 			= ""
	_name 			= ""
	_new-id 		= 0
	_upload-flag 	= false

	_init-depend-module = !->
		page 		:= 		require "./pageManage.js"
		main 		:= 		require "./mainManage.js"
		require_ 	:= 		require "./requireManage.js"

	_reset = !->
		_name-input-dom.val ''; _name 	:= ""
		_pic-input-dom.val null; _src 	:= ""
		_display-img-dom.css {"background-image" : ""}
		_new-id  						:= 0
		_upload-flag 					:= false


	_check-is-valid = ->
		_name := _name-input-dom.val()
		if _name.length is 0 then alert "请输入品类名称"; return false
		if _name.length > 21 then alert "输入的品类名称长度大于21"; return false
		if main.is-exist-name _name then alert "已存在该名字的品类, 请输入其他品类名"; return false
		if _pic-input-dom[0].files[0]
			if _pic-input-dom[0].files[0].type.substr(0, 5) isnt "image" then alert "请上传正确的格式图片"; return false
		return true

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

	_success-callback = !->
		main.add-new-category {
			name 	:	_name
			pic 	:	_src
			id 		:	_new-id
		}
		_reset!
		page.toggle-page "main"

	_cancel-btn-click-event = !->
		_reset!
		page.toggle-page "main"

	_save-btn-click-event = !->
		if not _check-is-valid! then return
		if _upload-flag
			_callback = !-> _upload-pic-event !->
				_success-callback!
		else
			_callback = !-> _success-callback!
		page.cover-page "loading"
		require_.get("add").require {
			data 		:		{
				JSON  	:		JSON.stringify({name:_name})
			}
			success 	: 		(result)!-> _new-id := result.id; _callback!
			always 		:		!-> page.cover-page "exit"
		}

	_pic-input-change-event = (input)!->
		if file = input.files[0]
			if ((fsize = parse-int(file.size)) / 1024).to-fixed(2) > 4097 then alert "图片大小不能超过4M"
			else
				_upload-flag := true
				_src := util.getObjectURL file
				_display-img-dom.css {"background-image":"url(#{_src})"}

	_init-all-event = !->
		_cancel-btn-dom.click !-> _cancel-btn-click-event!

		_save-btn-dom.click !-> _save-btn-click-event!

		_pic-input-dom.change !-> _pic-input-change-event @


	initial: !->
		_init-all-event!
		_init-depend-module!


module.exports = new-manage

