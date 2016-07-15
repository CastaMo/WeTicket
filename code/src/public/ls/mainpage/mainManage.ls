#主要交互逻辑
main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = require_ = null
	_change-profile = {}
	_movies = []
	_tickets = []
	_user = {}
	_ticket = {}
	_seat = []
	_type = ['喜剧', '动作', '剧情', '爱情', '动画', '冒险', '奇幻', '音乐', '惊悚', '历史', '犯罪', '战争', '悬疑', '恐怖', '运动', '武侠']

	#电影类
	class Movie
		(options)!->
			deep-copy options, @
			_movies.push @

	#电影票类
	class Ticket
		(options)!->
			deep-copy options, @
			_tickets.push @

	#将JSON-hide中进行预处理
	_init-all-data = !->
		allArrJSON = $('#JSON-hide').html!
		movieArr = []
		ticketArr = []
		movieArr = JSON.parse(allArrJSON).allData.movies
		ticketArr = JSON.parse(allArrJSON).allData.tickets
		_user := JSON.parse(allArrJSON).allData.user
		console.log "_user", _user
		if movieArr
			for movie in movieArr
				new Movie(movie)
		console.log "_movies", _movies
		if ticketArr
			for ticket in ticketArr
				new Ticket(ticket)
		console.log "_tickets", _tickets

	#初始化我的首页中的电影票
	_init-ticket-page = !->
		if !_tickets
			for i from 0 to _tickets.length-1 by 1
				_single-ticket-dom = $ "<div class = 'personal-ticket-single'>
											<div class = 'delete-btn'></div>
											<div class = 'personal-ticket-single-name'></div>
											<div class = 'personal-ticket-single-img'></div>
											<div class = 'personal-ticket-single-QRcode'></div>
											<div class = 'personal-ticket-single-time'></div>
											<div class = 'personal-ticket-single-cinema'></div>
											<div class = 'personal-ticket-single-seat'></div>
											<div class = 'personal-ticket-single-feel'></div>
										</div>"
				_single-ticket-dom.find('.personal-ticket-single-name').html("#{_tickets[i].movie_name}")
				_single-ticket-dom.find('.personal-ticket-single-name').val("#{_tickets[i]._id}")
				_single-ticket-dom.find('.personal-ticket-single-time').html("#{_tickets[i].time}")
				_single-ticket-dom.find('.personal-ticket-single-cinema').html("#{_tickets[i].cinema_name}")
				_single-ticket-dom.find('.personal-ticket-single-seat').html("#{_tickets[i].hail_number} 号厅 - #{_tickets[i].seat_coordinate[0]}排#{_tickets[i].seat_coordinate[1]}座")
				_single-ticket-dom.find('.personal-ticket-single-feel').html("#{_tickets[i].des}")
				#单个电影票跳转到修改电影票点击事件
				_single-ticket-dom.click !->
					target = $(event.target)
					if target.is('.delete-btn')
						return false
					else 
						$('.personal-ticket-pre-name').html($(@).find('.personal-ticket-single-name').html!)
						$('.personal-ticket-pre-time').html($(@).find('.personal-ticket-single-time').html!)
						$('.personal-ticket-pre-cinema').html($(@).find('.personal-ticket-single-cinema').html!)
						$('.personal-ticket-pre-seat').html($(@).find('.personal-ticket-single-seat').html!)
						$('.personal-ticket-pre-feel').html($(@).find('.personal-ticket-single-feel').html!)
						page.toggle-page "personal"
				#删除电影票点击事件
				_single-ticket-dom.find('.delete-btn').click !->
					_delete-obj = {}
					_delete-obj.id = $(@).parent().find('.personal-ticket-single-name').val!
					require_.get("delete").require {
						data 		:		{
							JSON 	:		JSON.stringify(_delete-obj)
						}
						callback 	:		(succes)!-> alert('删除成功');_hide-ticket _delete-obj.id
					}
				$('.personal-ticket-content').append _single-ticket-dom

	#删除电影票后隐藏该电影票
	_hide-ticket = (id)!->
		for i from 0 to _tickets.length-1 by 1
			if id is $('.personal-ticket-single').eq(i).find('.personal-ticket-single-name').val!
				$('.personal-ticket-single').eq(i).hide()

	#初始化首页中的电影
	_init-movie-page = !->
		if _user
			$('.user-name').html("#{_user.user_name}")
			$('.user-login').fade-in 100
			$('.user-logout').fade-in 100
		else if !_user
			$('.user').fade-in 100
		#正在热映电影左栏的电影
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
			_ticket := {}
			_ticket.movie_name := _movies[0].movie_name
			page.toggle-page "step1"
		##正在热映电影右栏的电影
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
				_ticket := {}
				_ticket.movie_name := $(@).parent().find('.single-release-movie-title').html!
				page.toggle-page "step1"
			$('.release-movie-right').append _release-movie-single-dom
		#即将上映的电影
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
		#初始化屏幕选座
		for k from 0 to 89 by 1
			_checkbox-dom = $ "<div class = 'screen-seat false'>
									<input type = 'checkbox'></input>
								</div>"
			$('.choose-seat-screen-seat').append _checkbox-dom

	#非动态的点击事件
	_init-all-click = !->
		#点击logo刷新主页
		$('.logo').click !->
			location.reload('/')

		#跳转登录页面
		$('.login-btn').click !->
			page.toggle-page "login"

		#跳转登录页面
		$('.login-click').click !->
			page.toggle-page "login"

		#跳转注册页面
		$('.register-btn').click !->
			page.toggle-page "register"

		#跳转注册页面
		$('.register-click').click !->
			page.toggle-page "register"

		#close按钮事件
		$('.close-btn').click !->
			page.toggle-page "close"

		#cancel按钮事件
		$('.cancel-btn').click !->
			page.toggle-page "close"

		#return按钮事件
		$('.return-btn').click !->
			page.toggle-page "main"

		#跳转修改密码页面
		$('._modify-password').click !->
			page.toggle-page "modify-password"

		#退出事件
		$('.user-logout').click !->
			_logout = {}
			require_.get("logout").require {
				data 		:		{
					JSON 	:		JSON.stringify(_logout)
				}
				callback 	:		(succes)!-> location.reload!
			}

		#跳转修改个人信息页面
		$('._modify-profile').click !->
			$('._modify-user-name').val(_user.user_name)
			$('._modify-user-mail').val(_user.email)
			$('._modify-user-phone').val(_user.phone_number)
			page.toggle-page "modify-profile"

		#确认修改密码事件
		$('.modify-password-confirm').click !->
			_change-password = {}
			_change-password.user_name = _user.user_name
			_change-password.old_password = $('._modify-user-old').val!
			_change-password.password = $('._modify-user-new').val!
			require_.get("modify-password").require {
				data 		:		{
					JSON 	:		JSON.stringify(_change-password)
				}
				callback 	:		(succes)!-> alert('修改成功');page.toggle-page "close"
			}

		#确认修改个人信息事件
		$('.modify-profile-confirm').click !->
			_change-profile := {}
			_change-profile.user_name := _user.user_name
			_change-profile.email := $('._modify-user-mail').val!
			_change-profile.phone_number = $('._modify-user-phone').val!
			require_.get("modify-profile").require {
				data 		:		{
					JSON 	:		JSON.stringify(_change-profile)
				}
				callback 	:		(succes)!-> alert('修改成功');page.toggle-page "close";_renew-profile!
			}

		#详情页中购票跳转
		$('.de-purchase-btn').click !->
			_ticket := {}
			_ticket.movie_name := $('.information-title').html!
			page.toggle-page "step1"

		#购票步骤1跳转事件
		$('.step1-btn').click !->
			$('.choose-seat-screen-seat input').attr("checked", false)
			$('.choose-seat-screen-seat input').parent().removeClass "true"
			$('.choose-seat-screen-seat input').parent().addClass "false"
			_ticket.cinema_name := $('._choose-cinema').val!
			_ticket.hail_number := Number($('._choose-hall').val!)
			_ticket.time := $('._choose-date').val! + " " +$('._choose-season').val!
			page.toggle-page "step2"

		#购票步骤2跳转事件
		$('.step2-btn').click !->
			_seat := []
			for i from 1 to 90 by 1
				if $('.choose-seat-screen-seat .screen-seat').eq(i).hasClass("true")
					_seat.push(i)
			$('.login-purchase-sum').html("一共消费 #{45*_seat.length} 元")
			if _user
				page.toggle-page "step3-login"
			else if !_user
				page.toggle-page "step3-unlogin"

		#购票步骤3跳转事件
		$('.step3-btn').click !->
			if _seat.length is 0
				alert('请选择座位')
				page.toggle-page "step2"
			else if _seat.length isnt 0
				for i from 0 to _seat.length-1 by 1
					_coordinate = []
					_ticket.user_id = _user._id
					_coordinate.push(_seat[i]%10)
					_coordinate.push(((_seat[i]-(_seat[i]%10))/10)+1)
					console.log "_seat[i]", _seat[i]
					_ticket.seat_coordinate = _coordinate
					_ticket.price = 45
					_ticket.des = ""
					console.log "_ticket", _ticket
					require_.get("add").require {
						data 		:		{
							JSON 	:		JSON.stringify(_ticket)
						}
						callback 	:		(succes)!-> _addTicket succes.ticket
					}
				alert('购买成功')
				page.toggle-page "step4"

		#跳转我的首页
		$('.user-login').click !->
			$('.person-name').html("#{_user.user_name}")
			if _user.email isnt undefined
				$('.person-email').html("邮箱：#{_user.email}")
			if _user.phone_number isnt undefined
				$('.person-phone').html("电话号码：#{_user.phone_number}")
			page.toggle-page "person"

		#屏幕选座checkb事件
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

		#确认注册事件
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

		#确认登录事件
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

	#购买成功后添加电影票
	_addTicket = (ticket) !->
		_single-ticket-dom = $ "<div class = 'personal-ticket-single'>
									<div class = 'delete-btn'></div>
									<div class = 'personal-ticket-single-name'></div>
									<div class = 'personal-ticket-single-img'></div>
									<div class = 'personal-ticket-single-QRcode'></div>
									<div class = 'personal-ticket-single-time'></div>
									<div class = 'personal-ticket-single-cinema'></div>
									<div class = 'personal-ticket-single-seat'></div>
									<div class = 'personal-ticket-single-feel'></div>
								</div>"
		_single-ticket-dom.find('.personal-ticket-single-name').html("#{ticket.movie_name}")
		_single-ticket-dom.find('.personal-ticket-single-name').val("#{ticket._id}")
		_single-ticket-dom.find('.personal-ticket-single-time').html("#{ticket.time}")
		_single-ticket-dom.find('.personal-ticket-single-cinema').html("#{ticket.cinema_name}")
		_single-ticket-dom.find('.personal-ticket-single-seat').html("#{ticket.hail_number} 号厅 - #{ticket.seat_coordinate[0]}排#{ticket.seat_coordinate[1]}座")
		_single-ticket-dom.find('.personal-ticket-single-feel').html("#{ticket.des}")
		_single-ticket-dom.click !->
			target = $(event.target)
			if target.is('.delete-btn')
				return false
			else 
				$('.personal-ticket-pre-name').html($(@).find('.personal-ticket-single-name').html!)
				$('.personal-ticket-pre-time').html($(@).find('.personal-ticket-single-time').html!)
				$('.personal-ticket-pre-cinema').html($(@).find('.personal-ticket-single-cinema').html!)
				$('.personal-ticket-pre-seat').html($(@).find('.personal-ticket-single-seat').html!)
				$('.personal-ticket-pre-feel').html($(@).find('.personal-ticket-single-feel').html!)
				page.toggle-page "personal"
		_single-ticket-dom.find('.delete-btn').click !->
			_delete-obj = {}
			_delete-obj.id = $(@).parent().find('.personal-ticket-single-name').val!
			require_.get("delete").require {
				data 		:		{
					JSON 	:		JSON.stringify(_delete-obj)
				}
				callback 	:		(succes)!-> alert('删除成功');_hide-ticket _delete-obj.id
			}
		$('.personal-ticket-content').append _single-ticket-dom

	#刷新个人信息
	_renew-profile = !->
		$('.person-name').html("#{_user.user_name}")
		if _user.email isnt undefined
			$('.person-email').html("邮箱：#{_change-profile.email}")
		if _user.phone_number isnt undefined
			$('.person-phone').html("电话号码：#{_change-profile.phone_number}")

	#初始化所有事件
	_init-all-event = !->
		_init-all-data!
		_init-ticket-page!
		_init-movie-page!
		_init-all-click!

	#初始化其他js模块
	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ :=require "./requireManage.js"

	#初始化
	initial: !->
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
