sub-item-manage = let

	[		deep-copy] =
		[	util.deep-copy]

	class SubItem
		(options)->
			deep-copy options, @
			@init!
		init: !->

	class PropertySubItem extends SubItem

		_property-sub-items 					= []

		_current-property-sub-item-list-dom 	= null

		(options)->
			super options
			if @is-head then _property-sub-items.unshift @
			else _property-sub-items.push @

		_update-all-property-sub-item = !->
			for property-sub-item in _property-sub-items
				property-sub-item.update-self! 

		init: !->
			@init-all-prepare!
			@init-all-dom!
			@init-all-event!

		init-all-prepare: !->
			@is-top = -> return (_property-sub-items.index-of @) is 0

		init-all-dom: !->
			@init-content-dom!
			@init-all-detail-dom!

		init-all-event: !->
			@top-dom.click !~>
				if @is-top! then return
				@top-self!; _update-all-property-sub-item!
			@remove-dom.click !~>
				if _property-sub-items.length is 1 then return
				@remove-self!; _update-all-property-sub-item!

		init-content-dom: !->
			_get-content-dom = (property-sub-item)->
				dom = $ "<li class='content parallel-container'></li>"
				inner-html = 	"<div class='name-field'>
									<p>选项*</p>
									<input type='text'>
									</clear>
								</div>
								<div class='price-field'>
									<p>价差</p>
									<input placeholder='请填写数字以及+-号' type='number'>
									<div class='clear'></div>
								</div>
								<div class='oper-field parallel-container'>
									<div class='top' style='display:none;'>
										<div class='top-icon'></div>
									</div>
									<div class='remove'>
										<div class='remove-icon'></div>
									</div>
								</div>
								<div class='clear'></div>"
				dom.html inner-html
				if property-sub-item.is-head then _current-property-sub-item-list-dom.prepend dom
				else _current-property-sub-item-list-dom.append dom
				return dom

			@content-dom = _get-content-dom @


		init-all-detail-dom: !->
			@name-input-dom 	= @content-dom.find ".name-field input"; 	@name-input-dom.val @name
			@price-input-dom 	= @content-dom.find ".price-field input"; 	@price-input-dom.val @price; if Number(@price) is 0 then @price-input-dom.val 0
			@top-dom 			= @content-dom.find ".top"
			@remove-dom 		= @content-dom.find ".remove"

		get-copy-for-self: !->
			copy_ = {}
			deep-copy @, copy_
			deep-copy @get-value-from-input!, copy_
			return copy_

		top-self: !->
			options = @get-copy-for-self!
			options.is-head = true
			@remove-self!
			PropertySubItem.add-proprety-sub-item options

		remove-self: !->
			@content-dom.remove!
			@content-dom = null; @top-dom = null; @remove-dom = null
			_property-sub-items.splice _property-sub-items.index-of(@), 1

		update-self: !->
			if @is-top! then @top-dom.fade-out 100
			else @top-dom.fade-in 100

		get-value-from-input: ->
			return {
				name 		:		@name-input-dom.val!
				price 		:		@price-input-dom.val!
			}

		@add-proprety-sub-item = (options = {})!->
			property-sub-item = new PropertySubItem {
				name 		:		options.name 	|| ""
				price 		:		options.price 	|| ""
				is-head 	:		options.is-head || false
			}
			_update-all-property-sub-item!

		@reset = !->
			while _property-sub-items.length isnt 0
				property-sub-item = _property-sub-items[0]
				property-sub-item.remove-self!
			_property-sub-items := []
			_current-property-sub-item-list-dom := null

		@get-all-property-sub-items-value = ->
			r_ = []
			for property-sub-item in _property-sub-items
				r_.push property-sub-item.get-value-from-input!
			return r_

		@set-current-property-sub-item-dom-by-target = (options)!->
			_current-property-sub-item-list-dom 	:= options.property-sub-item-list-dom
			if options.content
				for property-sub-item in options.content
					@add-proprety-sub-item property-sub-item
			else @add-proprety-sub-item!

	initial: !->

	reset: !->
		PropertySubItem.reset!

	set-current-property-sub-item-dom-by-target: (options)!->
		PropertySubItem.reset!
		PropertySubItem.set-current-property-sub-item-dom-by-target options

	get-all-property-sub-items-value: -> return PropertySubItem.get-all-property-sub-items-value!

	add-proprety-sub-item: (options)!->
		PropertySubItem.add-proprety-sub-item options

module.exports = sub-item-manage
