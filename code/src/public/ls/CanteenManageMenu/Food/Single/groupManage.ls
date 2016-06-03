new_ = page = null

group-manage = let
	
	[		deep-copy, 			get-JSON] = 
		[	util.deep-copy,		util.get-JSON]

	_properties 							= {}
	_groups 								= {}

	_init-depend-module = !->
		new_ 	:= require "./newManage.js"
		page 	:= require "./pageManage.js"

	_init-all-event = !->

	_init-all-group = (_get-group-JSON)!->
		all-groups = get-JSON _get-group-JSON!
		for group in all-groups
			if group.type is "property" then property = new Property {
				id 			:		group.id
				name 		:		group.name
				content 	: 		group.content
				belong-to 	:		group.belong_to
			}

	class Group

		(options)->
			deep-copy options, @
			@init!
			_groups[@id] = @

		init: !->

	class Property extends Group

		_property-dom 							= $ "\#full-cover .property-field"
		_close-btn-dom 							= _property-dom.find ".close-btn"
		_property-content-list-dom  			= _property-dom.find "ul.property-content-list"
		_cancel-btn-dom 						= _property-dom.find ".cancel-btn"
		_confirm-btn-dom 						= _property-dom.find ".confirm-btn"

		_confirm-btn-click-event = !->
			while _current-property-sub-item-array.length isnt 0
				_current-property-sub-item-array.pop();
			new-group = Property.get-current-active-array!
			deep-copy new-group, _current-property-sub-item-array
			_init-property-sub-item-dom!
			page.cover-page "exit"

		_init-all-event = !->
			_close-btn-dom.click !-> page.cover-page "exit"

			_cancel-btn-dom.click !-> page.cover-page "exit"

			_confirm-btn-dom.click !-> _confirm-btn-click-event!

		###*************** 当前控制的属性组list对应的成员 start ******************###
		# 	property-sub-item-list-dom用于显示在'编辑'以及'新建'的属性组栏目里的属性子项
		# 	property-array存储当前显示的属性子项对应的id, 同时会在'编辑'以及'新建'完成后反馈给对应的dish中

		_current-property-sub-item-list-dom 	= null

		_current-property-sub-item-array 		= []

		###*************** 当前控制的属性组list对应的成员 end ******************###

		_remove-elem-from-property-array-by-target-id = (id_)!->
			for id, i in _current-property-sub-item-array
				if id is id_ then _current-property-sub-item-array.splice(i, 1); return
			alert "不存在对应属性组"

		_add-elem-to-property-array-by-target-id = (id_)!->
			for id, i in _current-property-sub-item-array
				if id is id_ then alert "已存在对应的属性组, 无法继续添加"; return
			_current-property-sub-item-array.push id_

		_set-property-sub-item-dom-and-array = (options)!->
			_current-property-sub-item-list-dom 			:= options.property-sub-item-list-dom
			_current-property-sub-item-array 				:= options.property-sub-item-array

		_init-property-sub-item-dom = !->
			_current-property-sub-item-list-dom.html ""
			for id in _current-property-sub-item-array
				_properties[id].add-sub-item-dom!

		(options)->
			super options, @
			_properties[@id] = @

		init: !->
			@init-all-prepare!
			@init-all-dom!
			@init-all-event!

		init-all-prepare: !->
			@active = false

		init-all-dom: !->
			@init-property-content-dom!

		init-all-event: !->
			@property-content-dom.click !~>
				if @active then @inactive-self!
				else @active-self!

		init-property-content-dom: !->
			_get-property-content-dom = (property)->
				dom = $ "<li class='property-content'>
							<div class='property-content-wrapper'>
								<div class='name-field'>
									<p class='name'>#{property.name}</p>
								</div>
								<div class='tick-field'>
									<div class='tick'></div>
								</div>
								<div class='clear'></div>
							</div>
						</li>"
				_property-content-list-dom.append dom
				return dom

			@property-content-dom = _get-property-content-dom @

		add-sub-item-dom: !->
			_get-sub-item-dom = (property)->
				dom = $ "<li class='sub-item'>
							<p>#{property.name}</p>
							<div class='delete-icon'></div>
							<div class='clear'></div>
						</li>"
				(dom.find ".delete-icon").click !->
					property.sub-item-delete-icon-click-event !->
						_remove-elem-from-property-array-by-target-id property.id

				_current-property-sub-item-list-dom.append dom
				return dom
			@sub-item-dom = _get-sub-item-dom @

		sub-item-delete-icon-click-event: (callback)!->
			@sub-item-dom.fade-out 100, !~>
				@sub-item-dom.remove!
				@sub-item-dom = null
				callback?!


		active-self: !-> @active = true; @property-content-dom.add-class "active"

		inactive-self: !-> @active = false; @property-content-dom.remove-class "active"

		reset: !-> @inactive-self!; if @sub-item-dom then @sub-item-delete-icon-click-event!

		@inactive-all = !->
			for id, property of _properties
				property.inactive-self!

		@active-property = !->
			@inactive-all!
			for id in _current-property-sub-item-array
				try
					_properties[id].active-self!
				catch error
					alert "管理端与后台未同步，请先刷新"

		@get-current-active-array = -> return [Number(id) for id, property of _properties when property.active]

		@set-current-property-sub-item-by-target = (options)!->
			_set-property-sub-item-dom-and-array options
			_init-property-sub-item-dom!

		@initial = !->
			_init-all-event!


	initial: (_get-group-JSON)!->
		_init-depend-module!
		_init-all-event!
		_init-all-group _get-group-JSON

		Property.initial!

	get-group-name-by-id: (id)-> if _groups[id] then return _groups[id].name else return ""

	get-group-type-by-id: (id)-> if _groups[id] then return _groups[id].type else return ""

	set-current-property-sub-item-by-target: (options)!-> Property.set-current-property-sub-item-by-target options

	set-current-property-active: !-> Property.active-property!

module.exports = group-manage


