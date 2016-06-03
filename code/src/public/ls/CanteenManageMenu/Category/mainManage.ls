page = edit = require_ =  null
main-manage = let
	[deep-copy, getJSON] 	=	 [util.deep-copy, util.getJSON]

	_categories = {}

	_init-all-category = (_get-category-JSON)!->
		all-categories = getJSON _get-category-JSON!
		for category, i in all-categories
			category_ = new Category {
				id 		:	category.id
				name	:	category.name
				pic 	:	category.pic
				is-head	:	category.is-head || false
			}

	_init-all-event = !->
		($ "\#category-main \#new-btn").click !->
			page.toggle-page "new"

	_init-depend-module = !->
		page 		:= 	require "./pageManage.js"
		edit 		:= 	require "./editManage.js"
		require_	:=	require "./requireManage.js"


	class Category
		_category-main-container-dom = $ "\#category-main .category-all-field \#t-body-field"
		(options)!->
			deepCopy options, @
			@init!
			_categories[@id] = @

		init: !->
			@init-dom!
			@init-all-event!

		init-all-event: !->
			(@dom.find ".remove").click !~> if confirm "确定要删除品类吗?(此操作无法恢复)" then
				page.cover-page "loading"
				require_.get("remove").require {
					data 			:	 {
						JSON 		:	JSON.stringify({id: @id})
					}
					success			:	(result)~> @remove-self!
					always 			:	!-> page.cover-page "exit"
				}
			(@dom.find ".top").click !~> 
				if @dom.prev!.length is 0 then alert "已经位于顶部"
				else 
					page.cover-page "loading"
					require_.get("top").require {
						data 		:	{
							id 		:	@id
						}
						success 	:	(result)~> @top-self!
						always 		:	!-> page.cover-page "exit"
					}
			(@dom.find ".edit").click !~>
				edit.get-category-and-show @
				page.toggle-page "edit"

		init-dom: !->
			_get-category-dom = (category)->
				dom = $ "<div></div>"; dom.attr {"class":'t-body category'}
				innerHTML = "<div class='t-first'>
									<p>#{category.name}</p>
								</div>
								<div class='t-second'>
									<div class='food-pic-field'>
										<div class='img default-category-image' #{if category.pic then "style=background-image:url(#{category.pic}?imageView2/1/w/100/h/100)" else ""}></div>
									</div>
								</div>
								<div class='t-third'>
									<div class='oper-field'>
										<div class='edit'>
											<div class='icon edit-icon'></div>
											<p>修改</p>
										</div>
										<div class='top'>
											<div class='icon top-icon'></div>
											<p>置顶</p>
										</div>
										<div class='remove'>
											<div class='icon remove-icon'></div>
											<p>删除</p>
										</div>
										<div class='clear'></div>
									</div>
								</div>
								<div class='clear'></div>"
				dom.html innerHTML
				if category.is-head then _category-main-container-dom.prepend dom
				else _category-main-container-dom.append dom
				dom

			@dom = _get-category-dom @
			@name-dom = @dom.find ".t-first p"
			@pic-dom = @dom.find ".t-second .food-pic-field .img"

		remove-self: !->
			@dom.fade-out 200, !~>
				@dom.remove!
				delete _categories[@id]

		top-self: !->
			@dom.remove!
			temp = {}; deep-copy @, temp
			delete _categories[@id]
			main-manage.add-new-category {
				name 		:		temp.name
				id 			:		temp.id
				pic 		:		temp.pic
				is-head 	:		true
			}

		edit-self: (options)!->
			if options.name isnt @name then @name = options.name; @name-dom.html @name
			if @pic = options.pic then @pic-dom.css {"background-image":"url(#{@pic})"}


	initial: (_get-category-JSON)!->
		_init-all-category _get-category-JSON
		_init-all-event!
		_init-depend-module!

	add-new-category: (options)-> category = new Category options

	is-exist-name: (name, id_)->
		[return true for id, category of _categories when category.name is name and (Number id) isnt (Number id_)]
		return false


module.exports = main-manage
