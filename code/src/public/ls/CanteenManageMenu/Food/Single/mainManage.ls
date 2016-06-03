header = group = page = edit = new_ = image = null
main-manage = let
	_state = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]

	_dishes = {}
	_dishes-array = {}
	_categories = {}
	_current-category-id = null
	_current-dish-id = []
	_is-all-choose = false

	_num-to-chinese = ["零","一","二","三","四","五","六","七","八","九","十"]

	_map-category-name-to-id 		= {}
	_food-single-select-dom 		= $ "select.food-single-select"
	_copy-select-dom 				= $ "select\#select-copy"
	_move-select-dom 				= $ "select\#select-move"
	_single-list-field-dom 			= $ ".single-list-field"
	_all-choose-field-dom 			= $ ".food-single-header-field .name-container > .t-choose"
	_all-choose-dom 				= _all-choose-field-dom.find ".choose-pic"

	_init-depend-module = !->
		image 		:= require "./imageManage.js"
		header 		:= require "./headerManage.js"
		group 		:= require "./groupManage.js"
		page 		:= require "./pageManage.js"
		edit 		:= require "./editManage.js"
		new_ 		:= require "./newManage.js"

	_init-all-food = (_get-food-JSON)!->
		all-foods = get-JSON _get-food-JSON!
		_first-category = null
		for category, i in all-foods
			category_ = new Category {
				seqNum 		:		i
				name 		:		category.name
				id 			:		category.id
			}
			if i is 0 then _first-category = category_
			for dish in category.dishes
				if dish.type is "normal" then category_.add-dish dish
		if _first-category then _first-category.select-self-event!

	_init-all-event = !->
		_food-single-select-dom.change !-> _categories[_map-category-name-to-id[@value]].select-self-event!
		_all-choose-field-dom.click _click-all-choose-event


	###
	#	header全选点击事件，由_is-all-choose这个标志变量决定。
	# 	如果_is-all-choose为true，则全部反选，否则全选
	###
	_click-all-choose-event = !->
		if _is-all-choose then _unchoose-current-all-dish!
		else _choose-current-all-dish!
			
	###
	# 	执行全选
	###
	_choose-current-all-dish = !->
		if not _current-category-id then return
		_is-all-choose := true; _all-choose-dom.add-class "choose"
		for dish in _dishes-array[_current-category-id]
			dish.choose-self!

	###
	# 	执行反选
	###
	_unchoose-current-all-dish = !->
		if not _current-category-id then return
		_is-all-choose := false; _all-choose-dom.remove-class "choose"
		for dish in _dishes-array[_current-category-id]
			dish.unchoose-self!


	###
	#	获取优惠信息相关的字符串
	#	@param 		{String} 	dcType 	: 优惠类型
	# 	@param 		{Number} 	dc 		: 优惠系数，根据类型不同而不同
	# 	@return 	{String} 	dcInfo 	: 优惠信息
 	###
	_get-dc-info = (dc-type, dc)->
		if dc-type is "discount"
			if dc % 10 is 0 then num = _num-to-chinese[Math.round dc/10]
			else num = dc / 10
			return "#{num}折"
		else if dc-type is "sale" then return "减#{dc}元"
		else if dc-type is "half" then return "第二份半价"
		else if dc-type is "limit" then return "剩#{dc}件"
		""

	###
	# 	将选中的餐品id添加至临时数组中, 并传递给header模块，用于更新header操作的可用性
	###
	_update-choose-dish = !->
		_current-dish-id := []
		for dish, i in _dishes-array[_current-category-id]
			if dish.is-choose then _current-dish-id.push dish.id
		header.check-all-control-headers-by-current-dish-id _current-dish-id

	###
	#	每次完成操作都要执行的回调函数
	###
	_general-callback = !->
		_unchoose-current-all-dish!

	class Category

		(options)!->
			deep-copy options, @
			_map-category-name-to-id[@name] = @id
			_categories[@id] = @
			_dishes[@id] = {}
			_dishes-array[@id] = []
			@init!

		_unshow-all-single-list = !->
			for id, category of _categories
				category.unshow-single-list-dom!

		init: !->
			@init-all-dom!
			@init-all-event!

		init-all-dom: !->
			@init-select-option-dom!
			@init-single-list-dom!

		init-all-event: !->

		###
		#	给品类select框添加option
		###
		init-select-option-dom: !->
			select-option-dom = $ "<option value='#{@name}'>#{@name}</option>"
			_food-single-select-dom.append select-option-dom

			#为copy和move的select顺便也添加option，这么写主要是因为懒......
			select-option-dom = $ "<option value='#{@name}'>#{@name}</option>"
			_copy-select-dom.append select-option-dom
			select-option-dom = $ "<option value='#{@name}'>#{@name}</option>"
			_move-select-dom.append select-option-dom

		###
		# 	prototype:
		#	生成餐品对应的容器list
		###
		init-single-list-dom: !->
			_get-single-list-dom = (category)->
				single-list-dom = $ "<ul class='single-list' id='single-list-#{category.seqNum}'></ul>"
				_single-list-field-dom.append single-list-dom
				single-list-dom.css {"display": "none"}
				
			@single-list-dom = _get-single-list-dom @

		show-single-list-dom: !-> @single-list-dom.fade-in 100

		unshow-single-list-dom: !-> @single-list-dom.fade-out 100

		select-self-event: !->
			_unchoose-current-all-dish!
			_unshow-all-single-list!
			set-timeout (!~> @show-single-list-dom!), 100
			_current-category-id := @id



		###************ operation start **********###

		add-dish: (options)!->
			dish = new Dish {
				able 			:		options.able 		|| true
				default-price 	:		options.default_price
				detail 			:		options.detail 		|| ""
				id 				:		options.id
				c-name 			:		options.name 		|| ""
				e-name 			:		options.name2 		|| ""
				pic 			:		options.pic 		|| ""
				groups 			:		options.groups 		|| []
				tag 			:		options.tag 		|| ""
				category-id 	:		@id
				dc-type			:		options.dc_type		|| ""
				dc 				:		options.dc 			|| 0
				is-head 		:		options.is-head 	|| false
				type 			:		options.type 		|| "normal"
			}

		change-able-dish: (dish-id, able)!-> _dishes[@id][dish-id].change-able-self able

		remove-dish: (dish-id)!-> _dishes[@id][dish-id].remove-self!

		top-dish: (dish-id)!-> _dishes[@id][dish-id].top-self!

		move-dish: (dish-id, new-category-id)!->
			dish = _dishes[@id][dish-id]
			temp = dish.get-copy-for-options!
			dish.remove-self!
			_categories[new-category-id].add-dish temp

		copy-dish: (old-dish-id, new-category-id, new-dish-id)!->
			dish = _dishes[@id][old-dish-id]
			temp = dish.get-copy-for-options!; temp.id = new-dish-id
			_categories[new-category-id].add-dish temp

		edit-dish: (dish-id, options)!->
			dish = _dishes[@id][dish-id]
			dish.edit-self options

		###************ operation end **********###


		class Dish
			(options)!->
				deep-copy options, @
				@init!
				@update-self-dom!
				_dishes[@category-id][@id] = @
				if @is-head then _dishes-array[@category-id].unshift @
				else _dishes-array[@category-id].push @

			_get-single-content-dom = (dish)->
				dom = $ "<li class='single-content'>
							<div class='single-info'>
								<div class='t-choose'>
									<div class='choose-field'>
										<div class = 'choose-pic'></div>
									</div>
								</div>
								<div class='t-pic left-right-border'>
									<div class='pic-field'>
										<div class='pic default-square-image'></div>
									</div>
								</div>
								<div class='t-name'>
									<div class='name-field'>
										<p class='c-name'></p>
										<p class='e-name'></p>
									</div>
								</div>
								<div class='t-price left-right-border'>
									<div class='price-field'>
										<p></p>
									</div>
								</div>
								<div class='t-property'>
									<div class='property-field'></div>
								</div>
								<div class='t-dc left-right-border'>
									<div class='dc-field'></div>
								</div>
								<div class='t-remark'>
									<div class='remark-field'>
										<p></p>
									</div>
								</div>
								<div class='clear'></div>
							</div>
							<div class='single-cover'>
								<div class='hide-cover'>
									<p>售罄中</p>
								</div>
							</div>
						</li>"
				if dish.is-head then _categories[dish.category-id].single-list-dom.prepend dom
				else _categories[dish.category-id].single-list-dom.append dom
				dom

			init: !->
				@init-all-dom!
				@init-prepare!
				@init-all-event!

			init-all-dom: !->
				@init-single-content-dom!
				@init-all-detail-dom!

			init-prepare: !->
				@is-choose = false

			init-single-content-dom: !->
				@single-content-dom = _get-single-content-dom @
					
			init-all-detail-dom: !->
				@choose-dom = @single-content-dom.find ".t-choose .choose-pic"
				@pic-dom = @single-content-dom.find ".t-pic .pic"
				@c-name-dom = @single-content-dom.find ".t-name p.c-name"
				@e-name-dom = @single-content-dom.find ".t-name p.e-name"
				@default-price-dom = @single-content-dom.find ".t-price p"
				@property-dom = @single-content-dom.find ".t-property .property-field"
				@dc-dom = @single-content-dom.find ".t-dc .dc-field"
				@remark-dom = @single-content-dom.find ".t-remark p"
				@cover-dom = @single-content-dom.find ".hide-cover"

			init-all-event: !->
				(@single-content-dom.find ".t-choose").click !~> @click-choose-event!

			###
			# 	prototype
			#	根据自身的属性对dom作出变化
			###
			update-self-dom: !->
				_update-property-dom = (dish)!->
					dish.property-dom.html inner-html = ""
					len_ = (groups = dish.groups).length
					for i in [0 to 2]
						if not groups[i] then break
						inner-html += "<p>#{group.get-group-name-by-id groups[i]}</p>"
					if len_ > 3 then inner-html += "<p>余#{len_ - 3}项</p>"
					dish.property-dom.html inner-html

				_update-dc-dom = (dish)!->
					dish.dc-dom.html inner-html = ""
					inner-html = "<p>#{_get-dc-info dish.dc-type, dish.dc}</p>"
					dish.dc-dom.html inner-html

				@pic-dom.css {"background-image":""}
				//if @pic then @pic-dom.css {"background-image":"url(#{@pic})"}
				//
				if @pic then image.loading {
					is-div 		:		true
					url 		:		"#{@pic}"
					target-dom 	: 		@pic-dom[0]
				}
				if not @able then @cover-dom.fade-in 200
				else @cover-dom.fade-out 200
				@c-name-dom.html @c-name; @c-name-dom.attr {"title": @c-name}
				@e-name-dom.html @e-name; @e-name-dom.attr {"title": @e-name}
				@default-price-dom.html @default-price
				_update-property-dom @
				_update-dc-dom @
				@remark-dom.html @tag

			click-choose-event: !-> if @is-choose then @unchoose-self! else @choose-self!

			choose-self: !-> @is-choose = true; @choose-dom.add-class "choose"; _update-choose-dish!

			unchoose-self: !-> @is-choose = false; @choose-dom.remove-class "choose"; _update-choose-dish!
			
			###
			#	prototype:
			#	得到一份属性的拷贝，可用于构造一个新的餐品，由于新添的属性在后面会被覆盖故可以无视dom
			# 	work for copy and top
			###
			get-copy-for-options: ->
				temp = {}; deep-copy @, temp
				return {
					able 			:		temp.able
					default_price 	:		temp.default-price
					detail 			:		temp.detail
					id 				:		temp.id
					name 			:		temp.c-name
					name2 			:		temp.e-name
					pic 			:		temp.pic
					groups 			:		temp.groups
					tag 			:		temp.tag
					dc_type			:		temp.dc-type
					dc 				:		temp.dc
				}

			##**************** operation start *****************##

			edit-self: (options)!->
				deep-copy options, @
				@update-self-dom!

			change-able-self: (able)!->
				@able = able; @update-self-dom!

			remove-self: !->
				@single-content-dom.fade-out 200, !~>
					@single-content-dom.remove!
					for dish, i in _dishes-array[@category-id]
						if dish is @ then _dishes-array[@category-id].splice(i, 1); break
					delete _dishes[@category-id][@id]

			top-self: !->
				@single-content-dom.remove!
				temp = @get-copy-for-options!
				temp.is-head = true
				for dish, i in _dishes-array[@category-id]
					if dish is @ then _dishes-array[@category-id].splice(i, 1); break
				delete _dishes[@category-id][@id]
				_categories[_current-category-id].add-dish temp

			##**************** operation end *****************##



	initial: (_get-food-JSON)!->
		_init-depend-module!
		_init-all-event!
		_init-all-food _get-food-JSON

	get-dish-by-id: (dish-id)->
		if _dishes[_current-category-id] then return _dishes[_current-category-id][dish-id]
		else return null

	is-equal-for-category: (category-name)!->
		return _map-category-name-to-id[category-name] is _current-category-id

	toggle-to-edit-for-current-choose-dish: !->
		if _current-dish-id.length isnt 1 then alert "非法操作"; return
		page.toggle-page "edit"
		edit.toggle-callback _dishes[_current-category-id][_current-dish-id[0]], _current-category-id

	toggle-to-new: !->
		page.toggle-page "new"
		new_.toggle-callback _current-category-id

	get-current-dishes-id: -> return _current-dish-id

	get-category-id-by-name: (category-name)-> return _map-category-name-to-id[category-name]


	###
	#	改变当前选中的dishes的able，判断是否显示到webAPP上
	#	@param 		{Boolean} 		able: 是否可用
	###
	change-able-for-current-choose-dishes-by-given: (able)!->
		if not _current-category-id then alert "非法操作!"; return
		_current-category = _categories[_current-category-id]
		for id in _current-dish-id
			_current-category.change-able-dish id, able
		_general-callback!

	###
	#	删除当前选中的dishes
	###
	remove-for-current-choose-dishes: !->
		if not _current-category-id then alert "非法操作!"; return
		_current-category = _categories[_current-category-id]
		for id in _current-dish-id
			_current-category.remove-dish id
		_general-callback!

	###
	#	置顶当前选中的dishes
	###
	top-for-current-choose-dishes: !->
		if not _current-category-id then alert "非法操作!"; return
		_current-category = _categories[_current-category-id]
		while _current-dish-id.length isnt 0
			id = _current-dish-id.pop!
			_current-category.top-dish id
		_general-callback!

	###
	#	移动当前选中的dishes到指定的品类中
	#	@param 		{String} 		dest-category-name: 目标品类名
	###
	move-for-current-choose-dishes-by-given: (dest-category-name)!->
		if not _current-category-id then alert "非法操作!"; return
		dest-category-id = _map-category-name-to-id[dest-category-name]
		_current-category = _categories[_current-category-id]
		for id in _current-dish-id
			_current-category.move-dish id, dest-category-id
		_general-callback!

	###
	#	复制当前选中的dishes到指定的品类中
	#	@param 		{String} 		dest-category-name: 目标品类名
	###
	copy-for-current-choose-dishes-by-given: (dest-category-name, new-dish-id-map)!->
		if not _current-category-id then alert "非法操作!"; return
		dest-category-id = _map-category-name-to-id[dest-category-name]
		_current-category = _categories[_current-category-id]
		for old-id in _current-dish-id
			_current-category.copy-dish old-id, dest-category-id, new-dish-id-map[old-id]
		_general-callback!

	###
	#	编辑当前的餐品
	#	@param 		{Number} 		dish-id: 目标餐品id
	# 	@param 		{Object} 		options: 餐品的属性配置
	###
	edit-for-current-choose-dish-by-given: (dish-id, options)!->
		if not _current-category-id or not dish-id then alert "非法操作!"; return
		_current-category = _categories[_current-category-id]
		_current-category.edit-dish dish-id, options
		_general-callback!

	###
	#	新建一个新的餐品到当前的品类中
	# 	@param 		{Object} 		options: 餐品的属性配置
	###
	create-dish-dish-by-given: (options)!->
		if not _current-category-id then alert "非法操作!"; return
		_current-category = _categories[_current-category-id]
		_current-category.add-dish options
		_general-callback!

module.exports = main-manage
