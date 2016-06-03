image-manage = let
	[		deep-copy] = 
		[	util.deep-copy]
	class ImageBuffer

		_currentLoadingNumber 	= 0
		_maxLoadingNumber 		= 0

		#该数组用于给对应的ImageBuffer提供现有的id，并且循环使用，保证互不冲突
		_indexArr 				= []

		#等待队列，用于存放将要加载图片的对象
		_waitingQueue 			= []

		#运行加载的容器，为了在移除对象的阶段提高效率，这里用键值对来加快查找速率，结合上述_indexArr一起使用
		_runningContainer 		= {}

		(options)->
			deep-copy options, @
			_waitingQueue.push @
			ImageBuffer.checkForLoading!

		readyForLoading: ->
			@allocResource!
			@defAllEvent!
			@beginLoad!

		allocResource: !-> @image = new Image

		defAllEvent: !->
			
			@image.onload = !~> @applyUrlToDom!; @releaseSelf!

			@image.onerror = !~> @releaseSelf!

			@image.onabort = !~> @releaseSelf!
		
		beginLoad: !-> @image.src = @url

		applyUrlToDom: !->
			if @isDiv then @targetDom.style.backgroundImage = "url(#{@url})"
			else @targetDom.src = self.url

		releaseSelf: !->
			_currentLoadingNumber--

			#归还id给_indexArr，以便循环使用
			_indexArr.push @id
			delete _runningContainer[@id]
			ImageBuffer.checkForLoading!



		@initial = (length = 3)!->
			_maxLoadingNumber 	:= length
			_indexArr  		 	:= [0 to _maxLoadingNumber - 1]

		@checkForLoading = !->
			if _waitingQueue.length is 0 then return
			if _currentLoadingNumber >= _maxLoadingNumber then return
			_currentLoadingNumber++

			#从waiting队列头取出将要加载图片的对象, 进行一系列初始化的工作
			readyObject 						= _waitingQueue.shift!
			readyObject.id 						= _indexArr.shift!
			_runningContainer[readyObject.id] 	= readyObject
			readyObject.readyForLoading!


	initial: !->
		ImageBuffer.initial!

	loading: (options)!->
		new ImageBuffer {
			targetDom 		:		options.targetDom 	|| null
			isDiv 			:		options.isDiv 		|| true
			url 			:		options.url 		|| ""
		}

module.exports = image-manage