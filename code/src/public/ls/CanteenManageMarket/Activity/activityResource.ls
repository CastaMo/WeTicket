# 'use strict';

# ActivityResource类用来实现activity模块前后端纯JSON数据传输

class Resource
  ->
    # @data = JSON.parse window.all-data
    @require = require './requireManage.js'
    @require.initial!

    @action!

  render-all-data: !->
    if @data.message is 'success'
      theme-activities = []
      reduce-activities = []

      @data.data.for-each (item)!->
        if item.type is 'theme'
          theme-activities.push item
        else
          reduce-activities.push item

      @render-theme-activities-data theme-activities
      @render-reduce-activities-data reduce-activities

  create-activity-item: (id, title, intro, pic)->
    li = document.create-element 'li'

    base-pic-url = 'http://static.brae.co/images/activity/'
    pic = base-pic-url + pic

    li.innerHTML = '<div class="id">' + id + '</div><div class="content"><div class="pic"><img src="'+ pic + '"/></div><div class="info"><div class="title">' + title + '</div><div class="brief">' + intro + '</div></div></div>'
    li

  render-theme-activities-data: (theme-activities)!->
    theme-activities-ul = $ '.theme-activities-list'
    theme-activities.for-each (item)!~>
      theme-activities-ul.append @create-activity-item(item.id, item.title, item.intro, item.pic)

  render-reduce-activities-data: (reduce-activities)!->
    reduce-activities-ul = $ '.reduce-activities-list'
    reduce-activities.for-each (item)!~>
      reduce-activities-ul.append @create-activity-item(item.id, item.title, item.intro, item.pic)

  get-activity-data-by-id: (id)->
    activity = null

    for item in @data.data
      if parse-int(item.id) is parse-int(id)
        activity = item

    activity

  upload-image-as-base64: (base64-str, success)!->
    base64-str = base64-str .substr base64-str.indexOf(';base64,') + 8
    token-and-key = {}

    _check-is-already-and-upload = !~>
      if base64-str and token-and-key.token and token-and-key.key
        opt =
          data:
            fsize: -1
            token: token-and-key.token
            key: btoa(token-and-key.key).replace("+", "-").replace("/", "_")
            url: base64-str
          success: !->
            success token-and-key.key
          always: !->

        console.log opt

        @require.get "picUpload" .require opt

    @require.get "picUploadPre" .require opt =
      data: {}
      success: (result)->
        console.log result
        token-and-key.token = result.token
        token-and-key.key = result.key
        console.log "token ready"
        _check-is-already-and-upload!
      always: !->

  update-image-as-base64-by-id: (id, base64-str, success)!->
    base64-str = base64-str .substr base64-str.indexOf(';base64,') + 8
    token-and-key = {}

    _check-is-already-and-upload = !~>
      if base64-str and token-and-key.token and token-and-key.key
        opt =
          data:
            fsize: -1
            token: token-and-key.token
            key: btoa(token-and-key.key).replace("+", "-").replace("/", "_")
            url: base64-str
          success: !->
            success token-and-key.key
          always: !->

        console.log opt

        @require.get "picUpload" .require opt

    @require.get "picUpdatePre" .require opt =
      data:
        id: id
      success: (result)->
        console.log result
        token-and-key.token = result.token
        token-and-key.key = result.key
        console.log "token ready"
        _check-is-already-and-upload!
      always: !->

  create-activity: (data, rootScope, success)!->
    rootScope.view.go-to-state ['\#category-main', '\#activity-spinner']

    set-timeout !~>
      @require.get 'create' .require opt =
        data: data
        success: (result)!->
          success result
        always: !->
          rootScope.view.go-to-state ['\#category-main']
    , 500

  delete-activity-by-id: (id, success, always)!->
    @require.get 'delete' .require opt =
      data: data =
        id: id
      success: success
      always: always

  update-activity: (data, rootScope, success)!->
    rootScope.view.go-to-state ['\#category-main', '\#activity-spinner']

    set-timeout !~>
      @require.get 'update' .require opt =
        data: data
        success: success
        always: !->
          rootScope.view.go-to-state ['\#category-main']
    , 500

  action: ->
    # @render-all-data!

    console.log 'Activity resource action!'

module.exports = Resource
