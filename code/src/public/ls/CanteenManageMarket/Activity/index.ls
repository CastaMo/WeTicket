# 'use strict';

# let win = window
	# Activity = require './activity.js'
	# win.activity = new Activity

# 为了开发效率和可维护性，activity模块改用angular框架

# ========== 初始化 =========
ng-app = 'BraecoActivity'
ng-app-module = angular.module ng-app, ['ngResource']
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false;
]

# ========== 手动引导ng-app ===========
angular.element document .ready !->
  angular.bootstrap document, [ng-app]

# ============ 引入模块 =============
View = require './activityView.js'
Controller = require './activityController.js'
Resource = require './activityResource.js'

# =============== 控制器 ================
ng-app-module.controller 'category-main', ['$rootScope', '$scope', '$resource', ($rootScope, $scope, $location, $resource)!->

  # ====== $rootScope定义变量 =======
  $rootScope.view = init-activity-view!
  $rootScope.resource = new Resource!
  $rootScope.controller = new Controller
  $rootScope.current-id = null
  $rootScope.current-activity = null

  # ======= $scope 定义变量 =======
  $scope.sales-activities = []
  $scope.theme-activities = []
  $scope.base-image-url = 'http://static.brae.co/images/activity/'
  $scope.activityName = ''
  $scope.expiryDate = 0
  $scope.activityStartDate
  $scope.activityEndDate
  $scope.activityUploadImage
  $scope.activityBrief = ''
  $scope.activityContent = ''
  $scope.is-addding-activity = false

  $scope.isNewThemeActivity = false
  $scope.isNewSaleActivity = false

  $scope.isEditActivity = true
  $scope.isNewActivity = false
  $scope.isImageChange = false

  $scope.activities-data = JSON.parse window.all-data

  $scope.pre-image-url = 'http://ww4.sinaimg.cn/large/ed796d65gw1f4etfd2bn8j20e807l0tw.jpg'

  $scope.createActivityType = 'sales'

  # ======= 初始化函数定义 =======
  datepicker-init = !->
    $('[data-toggle="datepicker"]').datepicker option =
      format: 'yyyy年mm月dd日'
      # startDate: new Date!

    $ '#activity-start-date' .change !->
      $ '#activity-end-date' .datepicker 'setStartDate', @value


  edit-area-init = !->
    set-timeout !->
      if $scope.sales-activities.length > 0
        set-edit-area $scope.sales-activities[0], $scope
        $($ '.reduce-activities-list li' .0) .add-class 'activity-item-background-color'
        $rootScope.current-id = $scope.sales-activities[0].id
        $rootScope.current-activity = $scope.sales-activities[0]
      else if $scope.theme-activities.length > 0
        set-edit-area $scope.theme-activities[0], $scope
        $($ '.theme-activities-list li' .0) .add-class 'activity-item-background-color'
        $rootScope.current-id = $scope.theme-activities[0].id
        $scope.sales-activities[0] = $scope.theme-activities[0]
    , 0

  new-activity-image-preview-init = !->
    # $ '#activity-upload-image' .change !->
    #   debugger
    #   $scope.pre-image-url = $ '#activity-image-preview' .attr 'src'

  # ======= 初始化操作 ========
  init-activity-data $scope
  $rootScope.controller.page-init!
  $rootScope.controller.letter-number-limit-init!
  $rootScope.controller.date-range-init!
  datepicker-init!
  edit-area-init!
  new-activity-image-preview-init!

  # ====== scope函数定义 ========
  $scope.deleteActivity = (event)!->
    if confirm '你确定删除该活动吗'
      success = !->
        new-activities-data = []
        $scope.activities-data.data.for-each (item)!->
          if parse-int(item.id) is not parse-int($scope.current-id)
            new-activities-data.push item
        $scope.activities-data.data = new-activities-data
        init-activity-data $scope
        alert '活动删除成功'

      always = !->
        $rootScope.view.go-to-state ['\#category-main']

      $rootScope.view.go-to-state ['\#category-main', '\#activity-spinner']
      set-timeout !->
        $rootScope.resource.delete-activity-by-id $scope.current-id, success, always
      , 0

  $scope.editActivity = (event)!->
    need-to-upload-image = false
    if $('#activity-image-preview').attr('src').indexOf('http://') is -1
      need-to-upload-image = true

    data =
      title: $ '#activity-name' .val!
      intro: $ '#activity-brief' .val!
      content: $ '#activity-content' .val!

    if parse-int($scope.expiry-date) is 0
      data.date_begin = 0
      data.date_end = 0
    else
      data.date_begin = parse-int((new Date($ '#activity-start-date' .datepicker 'getDate')).value-of! / 1000)
      data.date_end = parse-int((new Date($ '#activity-end-date' .datepicker 'getDate')).value-of! / 1000)

    console.log data
    debugger

    data.JSON = JSON.stringify data
    data.type = $rootScope.current-activity.type
    data.id = $rootScope.current-activity.id

    update-success-fun = (key)!->
      alert '活动修改成功'
      empty-activity = {title: '', date_end: '0', date_begin: '0', intro: '', content: '', pic: $scope.pre-image-url}
      set-edit-area empty-activity, $scope
      $ '#activity-upload-image' .val ''

      if typeof key isnt 'object'
        data.pic = key.substr(key.indexOf('activity/') + 9)

      if data.type is 'sales'
        new-sale-activities = []
        $scope.sales-activities.for-each (item, index, array)!->
          if item.id is data.id
            if !data.pic then data.pic = item.pic
            new-sale-activities.push data
          else
            new-sale-activities.push item

        $scope.sales-activities = new-sale-activities

      else
        new-theme-activities = []
        $scope.theme-activities.for-each (item, index, array)!->
          debugger
          if item.id is data.id
            if !data.pic then data.pic = item.pic
            new-theme-activities.push data
          else
            new-theme-activities.push item
        $scope.theme-activities = new-theme-activities

    if need-to-upload-image
      base64-src = $ '#activity-image-preview' .attr 'src'

      $rootScope.resource.update-image-as-base64-by-id data.id, base64-src, (key)!->
        console.log 'Upload image success'
        console.log key
        $rootScope.resource.update-activity data, $rootScope, !->
          console.log key
          update-success-fun key
    else
      $rootScope.resource.update-activity data, $rootScope, update-success-fun

  $scope.createActivity = (event)!->
    base64-src = $ '#activity-image-preview' .attr 'src'
    data =
      title: $scope.activityName
      intro: $scope.activityBrief
      content: $scope.activityContent

    if parse-int($scope.expiry-date) is 0
      data.date_begin = 0
      data.date_end = 0
    else
      data.date_begin = parse-int((new Date($ '#activity-start-date' .datepicker 'getDate')).value-of! / 1000)
      data.date_end = parse-int((new Date($ '#activity-end-date' .datepicker 'getDate')).value-of! / 1000)

    console.log data

    data.JSON = JSON.stringify data
    data.type = $scope.createActivityType

    $rootScope.resource.upload-image-as-base64 base64-src, (key)!->
      console.log 'Upload image success'
      console.log key
      $rootScope.resource.create-activity data, $rootScope, (result)!->
        alert '活动创建成功'
        data.id = result.id
        empty-activity = {title: '', date_end: '0', date_begin: '0', intro: '', content: '', pic: $scope.pre-image-url}
        set-edit-area empty-activity, $scope
        $ '#activity-upload-image' .val ''
        data.pic = key.substr(key.indexOf('activity/') + 9)
        if $scope.createActivityType is 'sales'
          $scope.sales-activities.push data
        else
          $scope.theme-activities.push data


  $scope.new-promotion-activity = (event)!->
    console.log event
    $scope.isNewSaleActivity = true
    $scope.isNewThemeActivity = false
    $scope.createActivityType = 'sales'

    $scope.isEditActivity = false
    $scope.isNewActivity = true
    $scope.isImageChange = true

    set-timeout !->
      $ '.reduce-activities-list' .animate {scrollTop: 9999}, 1000
      $ '.activity-items li' .remove-class 'activity-item-background-color'
      $ '.new-sale-activity' .add-class 'activity-item-background-color'

      empty-activity = {title: '', date_end: '0', date_begin: '0', intro: '', content: '', pic: $scope.pre-image-url}
      set-edit-area empty-activity, $scope
      $scope.activityName = ''
      $scope.activityBrief = ''
    , 0

  $scope.new-theme-activity = (event)!->
    $scope.isNewSaleActivity = false
    $scope.isNewThemeActivity = true
    $scope.createActivityType = 'theme'

    $scope.isEditActivity = false
    $scope.isNewActivity = true
    $scope.isImageChange = true

    set-timeout !->
      $ '.theme-activities-list' .animate {scrollTop: 9999}, 1000
      $ '.activity-items li' .remove-class 'activity-item-background-color'
      $ '.new-theme-activity-li' .add-class 'activity-item-background-color'

      empty-activity = {title: '', date_end: '0', date_begin: '0', intro: '', content: '', pic: $scope.pre-image-url}
      set-edit-area empty-activity, $scope
      $scope.activityName = ''
      $scope.activityBrief = ''
    , 0

  $scope.activity-item-click-event = (event)!->
    $scope.isImageChange = false
    $scope.isNewSaleActivity = false
    $scope.isNewThemeActivity = false
    $scope.isEditActivity = true
    $scope.isNewActivity = false
    $rootScope.current-id = @activity.id
    $rootScope.current-activity = @activity

    $ '.activity-items li' .remove-class 'activity-item-background-color'
    $ event.current-target .add-class 'activity-item-background-color'

    set-edit-area @activity, $scope

]

# 统计中英文字符个数
get-total-num-length-of-cn-and-en-text = (str)->
  chineses = str.match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
  cn-len = if chineses then chineses.length else 0
  other-len = str.length - cn-len
  total = cnLen * 2 + other-len
  total

# 设置字数统计标签的值
set-letter-number-label = (title, intro, content)!->
  $ '.activity-name .letter-number' .text get-total-num-length-of-cn-and-en-text(title) + ' / 10'
  $ '.activity-brief .letter-number' .text get-total-num-length-of-cn-and-en-text(intro) + ' / 40'
  $ '.activity-content .letter-number' .text get-total-num-length-of-cn-and-en-text(content) + ' / 200'

# 设置编辑区的值
set-edit-area = (activity, scope)!->
  $ '#activity-name' .val activity.title
  $ '#activity-brief' .val activity.intro
  $ '#activity-content' .val activity.content

  if activity.pic.index-of('http://') is -1
    $ '#activity-image-preview' .attr 'src', scope.base-image-url + activity.pic
  else
    $ '#activity-image-preview' .attr 'src', activity.pic

  if parse-int(activity.date_begin) is 0 and parse-int(activity.date_end) is 0
    $ '#expiry-date' .val 0
    $ '#activity-start-date' .val ''
    $ '#activity-end-date' .val ''
    $ '.date-range label' .add-class 'disabled'
    $ ".date-range input" .prop 'disabled', true
  else
    $ '#expiry-date' .val 1
    $ '.date-range label' .remove-class 'disabled'
    $ ".date-range input" .prop 'disabled', false
    $ '#activity-start-date' .datepicker 'setDate', new Date(parse-int(activity.date_begin + '000'))
    $ '#activity-end-date' .datepicker 'setDate', new Date(parse-int(activity.date_end + '000'))

  set-letter-number-label activity.title, activity.intro, activity.content


# 初始化活动数据
init-activity-data = (scope)!->
  scope.theme-activities = []
  scope.sales-activities = []
  scope.activities-data.data.for-each (item)!->
    if item.type is 'theme'
      scope.theme-activities.push item
    else
      scope.sales-activities.push item

# 初始化view
init-activity-view = ->
  view = new View options =
    initial: ['\#category-main']
    views: ['\#category-main', '\#upload-canteen-image', '\#activity-spinner']
    transitions: [
      {
        from: ['\#category-main']
        to: ['\#category-main', '\#upload-canteen-image']
        on: ['.upload-canteen-photo click']
      },
      {
        from: ['\#category-main', '\#upload-canteen-image']
        to: ['\#category-main']
        on: ['.upload-canteen-image-mask click', '.upload-canteen-image-close click', '\#canteen-image-cancel click']
      }
    ]
    show-state: ['activity-fade-in']
    hide-state: ['activity-fade-out']
    init-state: ['activity-init']
  view
