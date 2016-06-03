main-manage = let

    _start-date-input-dom = $ '\#refund-order-main .start-date'
    _end-date-input-dom = $ '\#refund-order-main .end-date'
    _search-btn-dom = $ "\#refund-order-main .search-btn"
    _export-form-dom = $ "\#refund-order-main \#export-form"
    _export-form-st-dom = $ "\#refund-order-main \#export-form-st"
    _export-form-en-dom = $ "\#refund-order-main \#export-form-en"
    _export-btn-dom = $ "\#refund-order-main .export-btn"
    
    
    _init-datepicker = !->
        $('[data-toggle="datepicker"]').datepicker {format: 'yyyy-mm-dd'}

    initial: !->
        _init-datepicker!

module.exports = main-manage