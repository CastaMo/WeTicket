refund-manage = let

    _close-button-dom = $ "\#full-cover .refund-close-button"

    _full-cover-dom = $ "\#full-cover"
    
    _refund-block-content-dom = $ ".refund-block-content"
    
    
    _data-obj = null
    _total-sum = 0

    _close-button-dom-click-event = !->
        _full-cover-dom.fade-out 100
        _clean-refund-block-content!
        _data-obj = null
        _total-sum := 0

    _sub-icon-click-event = (event)!->
        target = $ event.target
        current-num = parse-int _get-current-num-by-sub-icon target
        if current-num > 0
            current-num -= 1
        _set-current-num-by-sub-icon target,current-num
        _set-current-total _get-current-total!
        _unset-checkbox!
    
    _add-icon-click-event = (event)!->
        target = $ event.target
        current-num = parse-int _get-current-num-by-add-icon target
        max-num = parse-int _get-max-num-by-add-icon target
        if current-num < max-num
            current-num += 1
        _set-current-num-by-add-icon target,current-num
        _set-current-total _get-current-total!
        if _get-current-sum! === _total-sum
            _set-checkbox!
        
    _get-max-num-by-sub-icon = (sub-icon) ->
        sub-icon.next!.next!.text!
    
    _get-max-num-by-add-icon = (add-icon) ->
        add-icon.prev!.text!
    
    _get-current-num-by-add-icon = (add-icon) ->
        add-icon.prev!.prev!.text! 
    
    _get-current-num-by-sub-icon = (sub-icon) ->
        sub-icon.next!.text!
        
    _set-current-num-by-sub-icon = (sub-icon, current-num)!->
        sub-icon.next!.text current-num.to-string!
        
    _set-current-num-by-add-icon = (add-icon, current-num)!->
        add-icon.prev!.prev!.text current-num.to-string!
        
    _get-current-total = ->
        pri-tds = $ '.pri-td'
        cur-tds = $ '.cur-td'
        current-total = 0.0
        index = 0
        while index < pri-tds.length
            j-cur-td = $ cur-tds[index]
            j-pri-td = $ pri-tds[index]
            current-total += (parse-int j-cur-td.text!) * parse-float j-pri-td.text!
            index += 1
        Math.min current-total, parse-float _data-obj.price
    
    _get-current-sum = ->
        current-sum = 0
        cur-tds = $ '.cur-td'
        index = 0
        while index < cur-tds.length
            j-cur-td = $ cur-tds[index]
            current-sum += parse-int j-cur-td.text!
            index += 1
        current-sum
            
    
    _set-comfirm-button-disable = !->
        comfirm-button = $ ".refund-block .comfirm-btn"
        comfirm-button.add-class 'comfirm-btn-disable'
        comfirm-button.prop 'disabled', true
    
    _set-password-comfirm-button-disable = !->
        password-comfirm-button = $ ".refund-block .password-comfirm-btn"
        password-comfirm-button.add-class 'password-comfirm-btn-disable'
        password-comfirm-button.prop 'disabled', true
   
    _set-comfirm-button-able = !->
        comfirm-button = $ ".refund-block .comfirm-btn"
        comfirm-button.remove-class 'comfirm-btn-disable'
        comfirm-button.prop 'disabled', false
    
    _set-password-comfirm-button-able = !->
        password-comfirm-button = $ ".refund-block .password-comfirm-btn"
        password-comfirm-button.remove-class 'password-comfirm-btn-disable'
        password-comfirm-button.prop 'disabled', false
        
    _get-total-sum = !->
        for single-food in _data-obj.content
            if single-food.cat === 0
                continue
            _total-sum += single-food.sum
    
    _is-total-current-ok = ->
        if parse-float ($ "\#refund-money").text! == 0.0
            false
        else
            true

    _set-current-total = (current-total)!->
        if current-total === 0.0 or !_is-description-input-ok!
            _set-comfirm-button-disable!
            _password-block-disappear!
        else
            _set-comfirm-button-able!
        ($ "\#refund-money").text current-total.to-string!
        
    _set-all-max = !->
        cur-tds = $ '.cur-td'
        index = 0
        while index < cur-tds.length
            j-cur-td = $ cur-tds[index]
            j-cur-td.text j-cur-td.next!.text!
            index += 1
    
    _set-all-zero = !->
        cur-tds = $ '.cur-td'
        index = 0
        while index < cur-tds.length
            j-cur-td = $ cur-tds[index]
            j-cur-td.text "0"
            index += 1
    
    _checkbox-change-event = (event)!->
        if ($ event.target).is ':checked'
            _set-all-max!
            _set-current-total _get-current-total!
        else
            _set-all-zero!
            _set-current-total _get-current-total!
    
    _password-block-appear = !->
        ($ '.password-block').fade-in 100
        ($ '\#password-input').val ''
        
    _password-block-disappear = !->
        ($ '.password-block').fade-out 100
        ($ '\#password-input').val ''
        
    
    _is-description-input-ok = ->
        if ($ "\#description-input").val! === ''
            false
        else
            true
        
    _description-input-change-event = !->
        if ($ "\#description-input").val! !== '' and _is-total-current-ok!
            _set-comfirm-button-able!
        else
            _set-comfirm-button-disable!
            _password-block-disappear!
            
        
    _password-comfirm-btn-click-event = !->
        description = ($ "\#description-input").val!
        password = ($ "\#password-input").val!
        id-tds = $ '.id-td'
        refunds = []
        for id-td in id-tds
            j-id-td = $ id-td
            id = parse-int j-id-td.text!
            cur =  parse-int (j-id-td.parent!.find '.cur-td').first!.text!
            if cur === 0
                continue
            else if cur > 0
                for single-food in _data-obj.content
                    if single-food.id === id
                        refund-item = {}
                        refund-item.id = id
                        refund-item.property = single-food.property
                        refund-item.sum = cur
                        refunds.push refund-item
        description = description
        password = $.md5 password
        refund = JSON.stringify refunds
        $.ajax {type: "POST", url: "/order/refund/"+_data-obj.id, data: {
            "description": description,
            "password": password,
            "refund": refund
        }, dataType: 'JSON', success: _refund-post-success}
        _set-password-comfirm-button-disable!
    
    _refund-post-success = (data)!->
        refund-error-message = $ "\#refund-error-message"
        if data.message === 'success'
            location.reload!
        else if data.message === 'Wrong password'
            refund-error-message.text "密码错误"
        else if data.message === 'Invalid dish to refund'
            refund-error-message.text "非法的退款"
        else if data.message === 'Order not found'
            refund-error-message.text "订单未找到"
        else
            refund-error-message.text "错误"
        _set-password-comfirm-button-able!
        
    
    _unset-checkbox = !->
        ($ '\#all-refund-checkbox').attr 'checked', false
        
    _set-checkbox = !->
        ($ '\#all-refund-checkbox').attr 'checked', true

    _init-all-event = !->
        _close-button-dom.click !-> _close-button-dom-click-event!

    _clean-refund-block-content = !->
        _refund-block-content-dom.empty!
        
    _gene-refund-food-block-dom = !->
        refund-food-block-dom = $ "<div class='refund-food-block'></div>"
        refund-food-table-dom = $ "<table class='refund-food-table'></table>"
        refund-food-table-dom.append "<thead>
        <tr>
        <td class='table-cat-col'>项目</td>
        <td class='table-num-col'>数量</td>
        <td class='table-pri-col'>单价</td>
        </tr>
        </thead>"
        for single-food in _data-obj.content
            if single-food.cat === 0
                continue
            refund-food-table-dom.append _gene-food-table-row single-food
        refund-food-block-dom.append refund-food-table-dom
        _refund-block-content-dom.append refund-food-block-dom
    
    _gene-food-table-row = (single-food)->
        row-dom = $ "<tr></tr>"
        row-dom.append "<td class='id-td' style='display: none'>"+single-food.id+"</td>"
        td-name = $ "<td class='table-cat-col cat-td'>"+single-food.name+"</td>"
        if single-food.property.length > 0
            td-name.append $ "<span class='sub-food-item'>"+'（'+(single-food.property.join '、')+"）"+"</span>"
        row-dom.append td-name
        row-dom.append _gene-food-table-num-col single-food.sum
        row-dom.append "<td class='table-pri-col pri-td'>"+single-food.price+"</td>"
        $ row-dom
        
    _gene-food-table-num-col = (food-sum)->
        td-dom = $ "<td class='table-num-col'></td>"
        sub-icon-dom = $ "<icon class='sub-icon refund-sub-icon'></icon>"
        sub-icon-dom.click !-> _sub-icon-click-event event
        td-dom.append $ sub-icon-dom
        td-dom.append $ "<span class='cur-td'>0</span>"
        td-dom.append $ "<span style='display: none'>"+food-sum+"</span>"
        add-icon-dom = $ "<icon class='add-icon refund-add-icon'></icon>"
        add-icon-dom.click !-> _add-icon-click-event event
        td-dom.append $ add-icon-dom
        $ td-dom
        
    _gene-refund-promotion-block-dom = !->
        promotion-block-dom = $ "<div class='refund-promotion-block'></div>"
        for single-promotion in _data-obj.content
            if single-promotion.cat === 0
                promotion-block-dom.append $ "<span class='left-span'>"+single-promotion.name+"</span>"
                promotion-block-dom.append $ "<span class='right-span'>"+single-promotion.property[0]+"</span>"
                promotion-block-dom.append "<div class='clear'></div>"
        _refund-block-content-dom.append promotion-block-dom
    
    _gene-refund-reason-block-dom = !->
        reason-block-dom = $ "<div class='refund-reason-block'></div>"
        reason-block-dom.append "<span>退款原因*</span>"
        description-input-dom = $ "<input id='description-input' type='text' placeholder='必填，否则无法退款'>"
        description-input-dom.keyup !-> _description-input-change-event! 
        reason-block-dom.append description-input-dom
        reason-block-dom.append "<div class='clear'></div>"
        _refund-block-content-dom.append reason-block-dom
    
    _gene-refund-conclusion-block-dom = !->
        conclusion-block-dom = $ "<div class='refund-conclusion-block'></div>"
        span-checkbox-dom = $ "<span class='left-span'></span>"
        checkbox-dom = $ "<input class='left-span' type='checkbox' id='all-refund-checkbox'>"
        checkbox-dom.change !-> _checkbox-change-event event
        span-checkbox-dom.append checkbox-dom
        span-checkbox-dom.append $ "<div class='left-span'>全单退款</div>"
        span-checkbox-dom.append $ "<div class='clear'></div>"
        conclusion-block-dom.append span-checkbox-dom
        conclusion-block-dom.append "<span class='right-span'>
        <span>退款总价：</span>
        <span id='refund-money'>0</span>
        </span>"
        conclusion-block-dom.append "<div class='clear'></div>"
        _refund-block-content-dom.append conclusion-block-dom
    
    _gene-refund-button-block-dom = !->
        button-block-dom = $ "<div class='refund-button-block'></div>"
        cancel-btn-dom = $ "<button class='cancel-btn'>取消</button>"
        cancel-btn-dom.click !-> _close-button-dom-click-event!
        button-block-dom.append cancel-btn-dom
        comfirm-btn-dom = $ "<button class='comfirm-btn comfirm-btn-disable'>确认</button>"
        comfirm-btn-dom.click !-> _password-block-appear!
        comfirm-btn-dom.prop 'disabled', true
        button-block-dom.append comfirm-btn-dom
        password-block-dom = $ "<div class='password-block' style='display: none'></div>"
        password-block-dom.append $ "<div class='password-block-info'>请输入密码，确认执行退款</div>"
        password-block-dom.append $ "<div id='refund-error-message'></div>"
        password-block-dom.append $ "<div class='password-block-input'><input id='password-input' type='password'></div>"
        
        password-block-button =  $ "<div class='password-block-button'></div>"
        password-comfirm-btn = $ "<button class='password-comfirm-btn'>确认</button>"
        password-comfirm-btn.click !-> _password-comfirm-btn-click-event!
        password-block-button.append password-comfirm-btn
        password-cancel-btn = $ "<button class='password-cancel-btn'>取消</button>"
        password-cancel-btn.click !-> _password-block-disappear!
        password-block-button.append password-cancel-btn
        
        password-block-dom.append password-block-button
        
        button-block-dom.append password-block-dom
        _refund-block-content-dom.append button-block-dom
    
    _gene-sperate-block-dom = !->
        _refund-block-content-dom.append "<div class='sperate-block'></div>"
    
    _hide-print-page = !->
        print-page-dom = $ "\#full-cover .print-block"
        refund-page-dom = $ "\#full-cover .refund-block"
        print-page-dom.hide!
        refund-page-dom.show!
    
    initial-refund-page: (data-obj)!->
        _hide-print-page!
        _clean-refund-block-content!
        _data-obj := data-obj
        _get-total-sum!
        _gene-refund-food-block-dom!
        _gene-sperate-block-dom!
        _gene-refund-promotion-block-dom!
        _gene-refund-reason-block-dom!
        _gene-refund-conclusion-block-dom!
        _gene-sperate-block-dom!
        _gene-refund-button-block-dom!

    initial: !->
        _init-all-event!

module.exports = refund-manage