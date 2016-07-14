main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = require_ = null
	_movies = []
	_user = {}
	_type = ['喜剧', '动作', '剧情', '爱情', '动画', '冒险', '奇幻', '音乐', '惊悚', '历史', '犯罪', '战争', '悬疑', '恐怖', '运动', '武侠']

	class Movie
		(options)!->
			deep-copy options, @
			_movies.push @

	_init-all-movie = !->
		movieArrJSON = $('#JSON-hide').html!
		movieArr = []
		movieArr = JSON.parse(movieArrJSON).allData.movies
		_user := JSON.parse(movieArrJSON).allData.user
		console.log "_user", _user
		for movie in movieArr
			new Movie(movie)
		console.log "_movies", _movies

	_init-movie-page = !->
		if _user
			$('.user-name').html("#{_user.user_name}")
			$('.user-login').fade-in 100
		else if !_user
			$('.user').fade-in 100
		type = ''
		test = _movies[0].type.toString(2)
		for j from 0 to 15 by 1
			if test[j] is '1'
				type = type + _type[j] + ' '
		$('.release-movie-left .single-release-movie-img').css("background-image", "url(#{_movies[0].url})")
		$('.release-movie-left .single-release-movie-title').html("#{_movies[0].movie_name}")
		$('.release-movie-left .single-release-movie-title').val(_movies[0]._id)
		$('.release-movie-left .single-release-movie-information').html("#{_movies[0].duration_time}分钟 - #{type}")
		$('.release-movie-left').append _release-movie-single-dom
		$('.release-movie-left .single-release-movie-detail').click !->
			$('.information-title').html("#{_movies[0].movie_name}")
			$('.information-title').val(_movies[0]._id)
			$('.information-info').html("#{_movies[0].duration_time}分钟 - #{type}")
			$('.information-date').html("上映日期：#{_movies[0].release_time}")
			$('.information-des').html("剧情：#{_movies[0].des}")
			$('.detail-img').css("background-image", "url(#{_movies[0].url})")
			page.toggle-page "detail"
		$('.release-movie-left .single-release-movie-purchase').click !->
			page.toggle-page "step1"
		for i from 1 to 6 by 1
			type = ''
			test = _movies[i].type.toString(2)
			for j from 0 to 15 by 1
				if test[j] is '1'
					type = type + _type[j] + ' '
			_release-movie-single-dom = $ "<div class = 'single-release-movie'>
											<div class = 'single-release-movie-img'></div>
											<div class = 'single-release-movie-title'></div>
											<div class = 'single-release-movie-time'></div>
											<div class = 'single-release-movie-type'></div>
											<div class = 'single-release-movie-detail'>
												<span>查看详情>></span>
											</div>
											<div class = 'single-release-movie-purchase btn'>
												<span>购票</span>
											</div>
										</div>"
			_release-movie-single-dom.find('.single-release-movie-img').css("background-image", "url(#{_movies[i].url})")
			_release-movie-single-dom.find('.single-release-movie-title').html("#{_movies[i].movie_name}")
			_release-movie-single-dom.find('.single-release-movie-title').val(_movies[i]._id)
			_release-movie-single-dom.find('.single-release-movie-time').html("#{_movies[i].duration_time}分钟")
			_release-movie-single-dom.find('.single-release-movie-type').html("#{type}")
			_release-movie-single-dom.find('.single-release-movie-detail').click !->
				for m from 0 to 14 by 1
					if $(@).parent().find('.single-release-movie-title').val! is _movies[m]._id
						$('.information-title').html("#{_movies[m].movie_name}")
						$('.information-title').val(_movies[m]._id)
						$('.information-info').html("#{_movies[m].duration_time}分钟 - #{type}")
						$('.information-date').html("上映日期：#{_movies[m].release_time}")
						$('.information-des').html("剧情：#{_movies[m].des}")
						$('.detail-img').css("background-image", "url(#{_movies[m].url})")
				page.toggle-page "detail"
			_release-movie-single-dom.find('.single-release-movie-purchase').click !->
				page.toggle-page "step1"
			$('.release-movie-right').append _release-movie-single-dom
		for i from 7 to 14 by 1
			_soon-movie-single-dom = $ "<div class = 'single-soon-movie'>
											<div class = 'single-soon-movie-img'></div>
											<div class = 'single-soon-movie-title'></div>
											<div class = 'single-soon-movie-infomation'></div>
											<div class = 'single-soon-movie-date'></div>
											<div class = 'single-soon-movie-detail'>
												<span>查看详情>></span>
											</div>
										</div>"
			type = ''
			test = _movies[i].type.toString(2)
			for j from 0 to 15 by 1
				if test[j] is '1'
					type = type + _type[j] + ' '
			_soon-movie-single-dom.find('.single-soon-movie-img').css("background-image", "url(#{_movies[i].url})")
			_soon-movie-single-dom.find('.single-soon-movie-title').html("#{_movies[i].movie_name}")
			_soon-movie-single-dom.find('.single-soon-movie-title').val(_movies[i]._id)
			_soon-movie-single-dom.find('.single-soon-movie-infomation').html("#{_movies[i].duration_time}分钟 - #{type}")
			_soon-movie-single-dom.find('.single-soon-movie-date').html("#{_movies[i].release_time}")
			_soon-movie-single-dom.find('.single-soon-movie-detail').click !->
				for m from 0 to 14 by 1
					if $(@).parent().find('.single-soon-movie-title').val! is _movies[m]._id
						$('.information-title').html("#{_movies[m].movie_name}")
						$('.information-title').val(_movies[m]._id)
						$('.information-info').html("#{_movies[m].duration_time}分钟 - #{type}")
						$('.information-date').html("上映日期：#{_movies[m].release_time}")
						$('.information-des').html("剧情：#{_movies[m].des}")
						$('.detail-img').css("background-image", "url(#{_movies[m].url})")
				page.toggle-page "detail"
			$('.soon-movie').append _soon-movie-single-dom

	_init-all-click = !->
		$('.logo').click !->
			location.reload('/')

		$('.login-btn').click !->
			page.toggle-page "login"

		$('.login-click').click !->
			page.toggle-page "login"

		$('.register-btn').click !->
			page.toggle-page "register"

		$('.register-click').click !->
			page.toggle-page "register"

		$('.close-btn').click !->
			page.toggle-page "close"

		$('.cancel-btn').click !->
			page.toggle-page "close"

		$('.return-btn').click !->
			page.toggle-page "main"

		$('.de-purchase-btn').click !->
			page.toggle-page "step1"

		$('.step1-btn').click !->
			page.toggle-page "step2"

		$('.step2-btn').click !->
			if _user
				page.toggle-page "step3-login"
			else if !_user
				page.toggle-page "step3-unlogin"

		$('.step3-btn').click !->
			page.toggle-page "step4"

		$('.user-login').click !->
			$('.person-name').html("#{_user.user_name}")
			page.toggle-page "person"

		$('.screen-seat input').click !->
			_apply = $(@).parent()
			if _apply.hasClass("true")
				$(@).attr("checked", false)
				$(@).parent().removeClass "true"
				$(@).parent().addClass "false"
			else if _apply.hasClass("false")
				$(@).attr("checked", true)
				$(@).parent().removeClass "false"
				$(@).parent().addClass "true"

		$('.register-confirm').click !->
			request-object = {}
			request-object.user_name = $('.register-field ._user-name').val!
			request-object.password = $('.register-field ._user-password').val!
			require_.get("register").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				callback 	:		(succes)!-> alert('注册成功', true);setTimeout('location.reload()', 2000)
			}

		$('.login-confirm').click !->
			request-object = {}
			request-object.user_name = $('.login-field ._user-name').val!
			request-object.password = $('.login-field ._user-password').val!
			require_.get("login").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				callback 	:		(succes)!-> alert('登录成功', true);location.reload!
			}

	_init-all-event = !->
		_init-all-movie!
		_init-movie-page!
		_init-all-click!

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ :=require "./requireManage.js"

	initial: !->
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
