page = null
main-manage = let

    _new-button-dom = $ ".psm-header-new-button"

    _new-dom  =  $ '\#promotion-single-new'
    
    _td-water-number-dom = $ ".td-water-number-content"
    _order-details-container-dom = $ ".order-details-container"
    
    _hover-timer = null
    _leave-timer = null
    
    _new-btn-click-event = !->
        page.toggle-page "new"
        
    
         
    _td-water-number-hover-event = (event) !->
        target = $ event.target
        clear-timeout _leave-timer
        _hover-timer := set-timeout (-> target.next!.fade-in 100), 100
    
    _td-water-number-leave-event = (event) !->
        target = $ event.target
        clear-timeout _hover-timer
        _leave-timer := set-timeout (-> target.next!.fade-out 1), 1
   
    _init-all-event = !->
        _new-button-dom.click !-> _new-btn-click-event!
        _td-water-number-dom.hover !-> (_td-water-number-hover-event event), !-> _td-water-number-leave-event event
        
    _init-depend-module = !->
        page 	:= require "./pageManage.js"

    initial: !->
        console.log _td-water-number-dom.length
        _init-depend-module!
        _init-all-event!

module.exports = main-manage