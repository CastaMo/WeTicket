main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = null
	value = []
	dayAry = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
	test = 0
	payAry = ["现金支付", "支付宝", "微信支付", "百度钱包"]
	_modifyForBus-dom = $ "\#modifyForBus"
	_add-dom = $ "\.modifyAddTime"
	_del-dom = $ "\.modifyDelTime"
	_timerAll-dom = $"\#timerAll"
	_cancel-dom = $ "\.canBtn"
	_finish-dom = $ "\.finBtn"
	_run-dom = $ "\.run-btn"
	_stop-dom = $ "\.stop-btn"
	_weekday-dom = $ "\.weekday"
	_payment-dom = $ "\.payment"

	_init-all-event = !->
		_modifyForBus-dom.click !->
			page.toggle-page "mod"
		_finish-dom.click !->
			_save-form-value!
			_show-form-value!
			page.toggle-page "pre"
		_cancel-dom.click !->
			page.toggle-page "pre"
		_add-dom.click !->
			faNode = document.getElementById("timerAll")
			lastNode = faNode.lastChild
			newLastNode = lastNode.cloneNode(true)
			faNode.appendChild(newLastNode)
			$("\.modifyDelTime").click !->
				childNum = faNode.children.length
				if childNum != 1
					delNode = @parentNode
					faNode.removeChild(delNode)
		_del-dom.click !->
				faNode = document.getElementById("timerAll")
				childNum = faNode.children.length
				if childNum != 1
					delNode = @parentNode
					faNode.removeChild(delNode)
		_run-dom.click !->
			$("\#runBusiness").removeClass "free"
			$("\#runBusiness").addClass "choose"
			$("\#stopBusiness").removeClass "choose"
			$("\#stopBusiness").addClass "free"
			document.getElementById("runMes").innerHTML = '业务已启用'
			document.getElementById("stopMes").innerHTML = '停用本业务'
			document.getElementById("previewBusiness").style.color = '#333333'
			document.getElementById("previewBusiness").style.border-color = '#333333'
		_stop-dom.click !->
			$("\#runBusiness").removeClass "choose"
			$("\#runBusiness").addClass "free"
			$("\#stopBusiness").removeClass "free"
			$("\#stopBusiness").addClass "choose"
			document.getElementById("runMes").innerHTML = '启用本业务'
			document.getElementById("stopMes").innerHTML = '业务已停用'
			document.getElementById("previewBusiness").style.color = '#E7E7EB'
			document.getElementById("previewBusiness").style.border-color = '#E7E7EB'
		_weekday-dom.click !->
			if $(this).hasClass("true")
				$(this).removeClass "true"
				$(this).addClass "false"
			else if $(this).hasClass("false")
				$(this).removeClass "false"
				$(this).addClass "true"
		_payment-dom.click !->
			if $(this).hasClass("true")
				$(this).removeClass "true"
				$(this).addClass "false"
			else if $(this).hasClass("false")
				$(this).removeClass "false"
				$(this).addClass "true"

	_show-form-value = ->
		x = document.getElementById("myForm")
		pay = ''
		day = ''
		time = ''
		can = ''
		count = 0
		test = 0
		for i from 0 to 6 by 1
			if value[i] == 1
				day += dayAry[i] + '&nbsp&nbsp'
		document.getElementById("showDay").innerHTML = day
		for i from 7 to x.length-6 by 1
			if i%2 == 1
				if value[i] == '' || value[i+1] == ''
					time += ''
				else time += value[i] + '~'
			else if i%2 == 0
				if value[i] == '' || value[i-1] == ''
					time += ''
				else time += value[i] + '&nbsp&nbsp&nbsp'
		document.getElementById("showTime").innerHTML = time
		for i from x.length-5 to x.length-2 by 1
			if value[i] == 1
				test = i-(x.length-5)
				pay += payAry[test] + '&nbsp&nbsp'
				value[i] = 1
		document.getElementById("showPay").innerHTML = pay
		selNum = $ "\#selNum"
		can = selNum.find("option:selected").text()
		document.getElementById("showCan").innerHTML = can

	_save-form-value = ->
		x = document.getElementById("myForm")
		for i from 0 to 6 by 1
			if x.elements[i].checked == true
				value[i] = 1
			else value[i] = 0
		for i from 7 to x.length-6 by 1
			value[i] = x.elements[i].value
		for i from x.length-5 to x.length-2 by 1
			if x.elements[i].checked == true
				value[i] = 1
			else value[i] = 0

	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_save-form-value!
		_show-form-value!
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
