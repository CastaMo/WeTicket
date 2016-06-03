print-manage = let
    _order-id = null
    _printer = null

    _close-button-dom = $ "\#full-cover .print-close-button"
    _full-cover-dom = $ "\#full-cover"
    
    _cancel-button-dom = $ "\#full-cover .print-block-content .cancel-btn"
    _comfirm-button-dom = $ "\#full-cover .print-block-content .comfirm-btn"

    _close-button-dom-click-event = !->
        _full-cover-dom.fade-out 100
        printer-choose-block-dom = $ "\#full-cover .printer-choose-block"
        printer-choose-block-dom.empty!
    
    _cancel-button-dom-click-event = !->
        _full-cover-dom.fade-out 100
        printer-choose-block-dom = $ "\#full-cover .printer-choose-block"
        printer-choose-block-dom.empty!
    
    _set-comfirm-button-disable = !->
        _comfirm-button-dom.prop 'disabled', true
        _comfirm-button-dom.add-class "comfirm-btn-disable"
    
    _set-comfirm-button-able = !->
        _comfirm-button-dom.prop 'disabled', false
        _comfirm-button-dom.remove-class "comfirm-btn-disable"
        
    
    _comfirm-button-dom-click-event = !->
        checked-printer-ids = []
        ($ 'input:checkbox.printer-checkbox').each !->
            if this.checked
                checked-printer-ids.push parse-int ($ this).val!
        checked-printer-ids-json = JSON.stringify checked-printer-ids
        $.ajax {type: "POST", url: "/order/reprint/"+_order-id, data: { checked-printer-ids-json }, dataType: 'JSON', success: _print-success}
        _set-comfirm-button-disable!
    
    _print-success = (data)!->
        console.log data
        _set-comfirm-button-able!
        
        
    _hide-print-page = !->
        refund-page-dom = $ "\#full-cover .refund-block"
        print-page-dom = $ "\#full-cover .print-block"
        refund-page-dom.hide!
        print-page-dom.show!
    
    _gene-printer-chooser = (data)!->
        _printer := data.printer
        printer-choose-block-dom = $ "\#full-cover .printer-choose-block"
        for printer in data.printer
            print-item-dom = $ "<div class='printer-item'></div>"
            print-item-dom.append $ "<p>"+printer.remark+"</p>"
            input-dom = $ "<input type='checkbox' class='printer-checkbox'>"
            input-dom.val printer.id
            print-item-dom.append input-dom
            printer-choose-block-dom.append print-item-dom
        
    _get-printer-infomation = !->
        $.ajax {type: "POST", url: "/dinner/printer/get", dataType: 'JSON', success: _gene-printer-chooser}

    _init-all-event = !->
        _close-button-dom.click !-> _close-button-dom-click-event!
        _cancel-button-dom.click !-> _cancel-button-dom-click-event!
        _comfirm-button-dom.click !-> _comfirm-button-dom-click-event!

    initial-print-page: (order-id)!->
        _order-id := order-id
        _hide-print-page!
        _get-printer-infomation!
        
    
    initial: !->
        _init-all-event!
    
    
module.exports = print-manage
