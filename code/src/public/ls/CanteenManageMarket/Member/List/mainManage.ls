main-manage = let
	page = require_ = null
	jumpPage = null
	_length = ""
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	activityArr = $("")
	_members = []
	_search-dom = $ "\.search-btn"
	_last-page-dom = $ "\.lastPage"
	_next-page-dom = $ "\.nextPage"
	_jump-dom = $ "\.jump-btn"
	_table-title-dom = $ "\.table-title"
	_table-dom = $ "\#Info"
	_close-dom = $ "\.close-btn"
	_cancle-dom = $ "\.cancel-btn"
	_save-dom = $ "\.confirm-btn"
	_loop-id-dom = $ "\.table-title ._loop-id a"
	_loop-level-dom = $ "\.table-title ._loop-level a"
	_loop-exp-dom = $ "\.table-title ._loop-exp a"
	_loop-balance-dom = $ "\.table-title ._loop-balance a"

	_repalce-href = !->

	
	_init-all-event = !->
		$("._searchInput").keydown (event)!->
			if event.keyCode is 13 then _search-dom.trigger "click"
		
		$('#_input1').keydown (event)!->
			if event.keyCode is 13 then _save-dom.trigger "click"
		
		$('#_input2').keydown (event)!->
			if event.keyCode is 13 then _save-dom.trigger "click"
		
		$("._jump-input").keydown (event)!->
			if event.keyCode is 13 then _jump-dom.trigger "click"
		
		_search-dom.click !->
			searchNum = $('._searchInput').val!
			if searchNum.length > 0 and /^[0-9]+$/.test(searchNum) or searchNum.length is 0
				searchNum = Number(searchNum)
				_location = "/Manage/Market/Member/List?search=" + searchNum
				location.href = _location
			else alert("只能输入电话或编号")

		_last-page-dom.click !->
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if pageArr.pn > 1 then pageArr.pn--
			location.href = "/Manage/Market/Member/List?by=create_date&search=#{pageArr.search}&in=#{pageArr.in}&pn=" + pageArr.pn
			_init-table!

		_next-page-dom.click !->
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if pageArr.pn < pageArr.sum_pages then pageArr.pn++
			location.href = "/Manage/Market/Member/List?by=create_date&search=#{pageArr.search}&in=#{pageArr.in}&pn=" + pageArr.pn
			_init-table!

		_jump-dom.click !->
			jumpPage = $("._jump-input").val!
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if jumpPage >= 1 and jumpPage <= pageArr.sum_pages then pageArr.pn = jumpPage
			pageArrJSON = JSON.stringify(pageArr)
			$('#page-JSON-field').html(pageArrJSON)
			location.href = "/Manage/Market/Member/List?by=create_date&in=#{pageArr.in}&pn=" + pageArr.pn
			_init-table!

		_close-dom.click !->
			page.cover-page "exit"
			_init-table!

		_cancle-dom.click !->
			page.cover-page "exit"
			_init-table!

		_save-dom.click !->
			_length = _members.length
			modify-input = $('#_input1').val!
			parentID = $('.displayID').html!
			recharge-input = $('#_input2').val!
			request-object = {}
			for i from 0 to _length-1 by 1
				if Number(_members[i].id) is Number(parentID) and modify-input != ""
					_members[i].EXP = modify-input
					request-object.exp = modify-input;
					require_.get("modify").require {
						data 		:		{
							JSON 	:		JSON.stringify(request-object)
							user-id :		parentID;
						}
						success 	:		(result)!-> location.reload!
					}
				else if Number(_members[i].id) is Number(parentID) and recharge-input != ""
					request-object.amount = recharge-input;
					recharge-input = Number(_members[i].balance)+Number(recharge-input)
					recharge-input = Number(recharge-input)
					recharge-input = recharge-input.toFixed(2)
					_members[i].balance = Number(recharge-input)
					if $(".phoneNumber").html! is "-"
						request-object.phone = $("._suppPhone").val!
					else
						request-object.phone = $(".phoneNumber").html!
					require_.get("recharge").require {
						data 		:		{
							JSON 	:		JSON.stringify(request-object)
							user-id :		parentID;
						}
						success 	:		(result)!-> location.reload!
					}
			_update-members!
			_init-table!
			if $(".phoneNumber").html! is "-" and recharge-input != "" and /^[0-9]+$/.test($(".phoneNumber").val!) and $(".phoneNumber").val!.length is 11
				alert("我们已经发送一条短信给会员，会员按照手机短信提示后回复短信即可充值成功，请提示会员留意手机信息!")
			page.cover-page "exit"

	class Member
		(options)!->
			deep-copy options, @
			_members.push @

	_update-members = !->
		memberArrJSON = JSON.stringify(_members)
		$('#json-field').html = memberArrJSON

	_init-arry = !->
		memberArrJSON = $('#json-field').html!
		activityArr = []
		activityArr = JSON.parse(memberArrJSON)
		for member in activityArr
			new Member(member)


	_init-table = !->
		$('#_input1').val("")
		$('#_input2').val("")
		_length = _members.length
		$("._line").remove!
		for i from 0 to _length-1 by 1
			_new-dom = $ "<tr class='_line'>
							<td class='_displayID'></td>
							<td class='_id'></td>
							<td class='_phone'></td>
							<td class='_nick'></td>
							<td class='_level'></td>
							<td class='_exp'></td>
							<td class='_balance'></td>
							<td>
								<div class='modify btn'>
									<div class='modify-btn-image'></div>
									<p>修改积分</p>
								</div>
								<div class='recharge btn'>
									<div class='recharge-btn-image'></div>
									<p>充值</p>
								</div>
							</td>
						</tr>"
			_new-dom.find("._displayID").html(_members[i].id)
			_new-dom.find("._id").html(_members[i].id_of_dinner)
			_new-dom.find("._phone").html(_members[i].phone)
			_new-dom.find("._nick").html(_members[i].nick)
			_new-dom.find("._level").html(_members[i].level)
			_new-dom.find("._exp").html(_members[i].EXP)
			_new-dom.find("._balance").html(_members[i].balance + "元")
			_table-dom.last().append _new-dom
			_new-dom.find(".modify").click !->
				_now =	$(@).parent().parent()
				$(".displayID").html(_now.find("._displayID").html!)
				$(".modifyIntegral").html(_now.find("._exp").html!)
				$(".WechatName").html(_now.find("._nick").html!)
				$(".phoneNumber").html(_now.find("._phone").html!)
				$(".memberID").html(_now.find("._id").html!)
				_reduce = _now.find("._balance").html!
				_reduce = _reduce.replace("元", "")
				$(".parent").html(_now.find("._balance").html!)
				page.cover-page "modify"
			_new-dom.find(".recharge").click !->
				_now =	$(@).parent().parent()
				$(".displayID").html(_now.find("._displayID").html!)
				_reduce = _now.find("._balance").html!
				_reduce = _reduce.replace("元", "")
				$(".modifyIntegral").html(_reduce)
				$(".WechatName").html(_now.find("._nick").html!)
				if _now.find("._phone").html! == "-"
					$(".preview-wrapper").removeClass "_hasphone"
					$(".preview-wrapper").addClass "_nophone"
				else
					$(".preview-wrapper").removeClass "_nophone"
					$(".preview-wrapper").addClass "_hasphone"
				$(".phoneNumber").html(_now.find("._phone").html!)
				$(".memberID").html(_now.find("._id").html!)
				$(".parent").html(_now.find("._exp").html!)
				page.cover-page "recharge"
		pageArrJSON = $('#page-JSON-field').html!
		pageArr = JSON.parse(pageArrJSON)
		$(".page").html(pageArr.pn + "/" + pageArr.sum_pages)
		if pageArr.in is "DESC" then
			_loop-id-dom.attr("href", "?by=create_date&in=ASC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-level-dom.attr("href", "?by=EXP&in=ASC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-exp-dom.attr("href", "?by=EXP&in=ASC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-balance-dom.attr("href", "?by=balance&in=ASCC&search=#{pageArr.search}&pn=#{pageArr.pn}")
		else if pageArr.in is "ASC" then
			_loop-id-dom.attr("href", "?by=create_date&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-level-dom.attr("href", "?by=EXP&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-exp-dom.attr("href", "?by=EXP&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-balance-dom.attr("href", "?by=balance&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"

	initial: !->
		_init-arry!
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage