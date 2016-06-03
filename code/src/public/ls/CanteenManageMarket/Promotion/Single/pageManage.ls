page-manage = let

    $("\#Promotion-sub-menu").addClass "choose"
    $("\#promotion-nav li\#Single").addClass "choose"
    
    _main-dom = $ '\#promotion-single-main'
    _new-dom  =  $ '\#promotion-single-new'
    _edit-dom = $ '\#promotion-single-edit'
    _all-toggle-dom = [_main-dom, _new-dom, _edit-dom]
    
    _unshow-all-toggle-dom-except-given = (dom_)->
        for dom in _all-toggle-dom when dom isnt dom_
            dom.fade-out 100
    
    _toggle-page-callback = {
        "main"      :       let
            ->
                set-timeout (-> _main-dom.fade-in 100), 100
                _unshow-all-toggle-dom-except-given _main-dom
        "new"       :       let
            ->
                set-timeout (-> _new-dom.fade-in 100), 100
                _unshow-all-toggle-dom-except-given _new-dom

        "edit"      :       let
            ->
                set-timeout (-> _edit-dom.fade-in 100), 100
                _unshow-all-toggle-dom-except-given _edit-dom
    }
    
    
    initial: ->
    
    toggle-page: (page)->
        _toggle-page-callback[page]?!

module.exports = page-manage
