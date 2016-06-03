page 		= null
new_ 		= null
edit 		= null
require_ 	= null

main-manage = let
	[ 		deep-copy, 			get-JSON] =
		[	util.deep-copy, 	util.get-JSON]

	_properties 							= {}
	_groups 								= {}

	_new-btn-dom 		= $ ".property-new-btn-field .new-btn"

	_init-depend-module = !->
		page 		:= require "./pageManage.js"
		new_ 		:= require "./newManage.js"
		edit 		:= require "./editManage.js"
		require_ 	:= require "./requireManage.js"

	_init-all-event = !->

		_new-btn-dom.click !-> _new-btn-click-event!

	_init-all-group = (_get-group-JSON)!->
		all-groups = get-JSON _get-group-JSON!
		console.log all-groups
		for group in all-groups
			if group.type is "property" then main-manage.add-property group
		console.log _properties

	_new-btn-click-event = !-> page.toggle-page "new"; new_.toggle-callback!

	class Group

		(options)->
			deep-copy options, @
			@init!
			_groups[@id] = @

		init: !->

	class Property extends Group

		_property-list-dom 			= $ "ul.t-property-list" 

		(options)->
			super options
			@update-self-dom!
			_properties[@id] = @

		init: !->
			@init-all-dom!
			@init-all-event!

		init-all-dom: !->
			@init-property-dom!
			@init-all-detail-dom!

		init-all-event: !->

			@edit-dom.click !~>
				page.toggle-page "edit"
				edit.toggle-callback @

			@remove-dom.click !~>
				if not confirm "确定要删除属性组吗?(此操作无法恢复)" then return
				require_.get("remove").require {
					data 				:		{
						property-id 	:		@id	
					}
					success 			:		(result)!~> @remove-self!
				}

		init-property-dom: !->
			_get-property-dom = (property)->
				dom = $ "<li class='property parallel-container'>
							<div class='t-name'>
								<div class='name-field total-center'>
									<p></p>
								</div>
							</div>
							<div class='t-choose left-right-border'>
								<div class='choose-field total-center'></div>
							</div>
							<div class='t-spread'>
								<div class='spread-field total-center'></div>
							</div>
							<div class='t-using-num left-right-border'>
								<div class='using-num-field total-center'>
									<p></p>
								</div>
							</div>
							<div class='t-oper'>
								<div class='oper-field'>
									<div class='edit'>
										<div class='logo'></div>
										<p>修改</p>
									</div>
									<div class='remove'>
										<div class='logo'></div>
										<p>删除</p>
									</div>
									<div class='clear'></div>
								</div>
							</div>
						</li>"
				_property-list-dom.append dom
				return dom
			@property-dom = _get-property-dom @


		init-all-detail-dom: !->
			@name-dom 			= @property-dom.find ".t-name p"
			@choose-dom 		= @property-dom.find ".t-choose .choose-field"
			@spread-dom 		= @property-dom.find ".t-spread .spread-field"
			@using-num-dom 		= @property-dom.find ".t-using-num p"
			@edit-dom 			= @property-dom.find ".t-oper .edit"
			@remove-dom 		= @property-dom.find ".t-oper .remove"

		edit-self: (options)!->
			deep-copy options, @
			@update-self-dom!

		remove-self: !->
			@property-dom.fade-out 200, !~>
				@property-dom.remove!; @property-dom = null
				delete _properties[@id]
				delete _groups[@id]

		update-self-dom: !->

			_update-choose-and-spread-dom = (property)!->
				property.choose-dom.html ""
				property.spread-dom.html ""
				choose-and-spread = property.content
				choose-inner-html = ""
				spread-inner-html = ""
				for i in [0 to 2]
					if not choose-and-spread[i] then break
					add-char = ""; if (price = choose-and-spread[i].price) > 0 then add-char = "+"
					choose-inner-html += "<p>#{choose-and-spread[i].name}</p>"
					spread-inner-html += "<p>#{add-char}#{price}</p>"
				if (len_ = choose-and-spread.length) > 3
					choose-inner-html += "<p class='tail'>余#{len_ - 3}项</p>"
					spread-inner-html += "<p class='tail'>余#{len_ - 3}项</p>"
				property.choose-dom.html choose-inner-html
				property.spread-dom.html spread-inner-html

			@name-dom.html @name
			_update-choose-and-spread-dom @
			@using-num-dom.html @belong-to.length


	initial: (_get-group-JSON)!->
		_init-depend-module!
		_init-all-event!
		_init-all-group _get-group-JSON

	add-property: (options)!->
		property = new Property {
			id 			:		options.id
			name 		:		options.name
			content 	: 		options.content
			belong-to 	:		options.belong_to
			remark 		:		options.remark
		}

	edit-property: (options, property-id)!->
		_properties[property-id].edit-self options


module.exports = main-manage