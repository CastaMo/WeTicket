# 'use strict';

# ActivityController类进行数据绑定和相应的DOM操作
# todo: 把alert换成更人性化的弹窗

class Controller
  ->
    @action!

  page-init: !->
    $("\#Activity-sub-menu").add-class "choose"

  # 活动图片上传预览初始化
  upload-image-preview-enable: (input, image)->
    $ input .change !->
      read-url @, image

    read-url = (input, image)!->
      if input.files && input.files[0]
        reader = new FileReader!
        reader.onload = (e)->
          $ image .attr 'src', e.target.result .css 'background-color', 'white'

        reader.readAsDataURL input.files[0]

  upload-image-previews-init: !->
    input-and-previews = [
      {input: '\#activity-upload-image', preview: '\#activity-image-preview'},
      {input: '\#canteen-image-1', preview: '.image-uploader-preview-1'},
      {input: '\#canteen-image-2', preview: '.image-uploader-preview-2'},
      {input: '\#canteen-image-3', preview: '.image-uploader-preview-3'},
      {input: '\#canteen-image-4', preview: '.image-uploader-preview-4'},
      {input: '\#canteen-image-5', preview: '.image-uploader-preview-5'}
    ]

    input-and-previews.for-each (item)!~>
      @upload-image-preview-enable item.input, item.preview

  get-cliped-text = (text, num)->
    cliped-text = ''
    cliped-text-num = 0
    for i from 0 to num - 1
      if text[i].match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
        cliped-text-num += 2
      else
        cliped-text-num += 1
      if cliped-text-num > num
        return cliped-text
      else
        cliped-text += text[i]
    cliped-text

  get-total-num-length-of-cn-and-en-text = (str)->
    chineses = str.match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
    cn-len = if chineses then chineses.length else 0
    other-len = str.length - cn-len
    total = cnLen * 2 + other-len
    total

  get-total-num-length-of-cn-and-en-text: get-total-num-length-of-cn-and-en-text

  letter-number-limit-init: !->
    elements = [
      {input: '#activity-name', num: 10, letter-number: '.activity-name .letter-number'},
      {input: '#activity-brief', num: 40, letter-number: '.activity-brief .letter-number'},
      {input: '#activity-content', num: 200, letter-number: '.activity-content .letter-number'}
    ]

    elements.for-each (item)!->
      $ item.input .on 'input', (event)->
        total = get-total-num-length-of-cn-and-en-text @value
        $ item.letter-number .text total + ' / ' + item.num

      $ item.input .on 'change', (event)->
        total = get-total-num-length-of-cn-and-en-text @value
        if total > item.num
          cliped-text = get-cliped-text(@value, item.num)
          $ item.input .val cliped-text
          $ item.letter-number .text get-total-num-length-of-cn-and-en-text(cliped-text) + ' / ' + item.num

  date-range-init: !->
    $ '#expiry-date' .on 'change', (event)!->
      if @value is '0'
        $ '.date-range label' .add-class 'disabled'
        $ ".date-range input" .prop 'disabled', true
        $ ".date-range input" .prop 'required', false
        $ ".date-range input" .val ''

      else
        $ '.date-range label' .remove-class 'disabled'
        $ ".date-range input" .prop 'disabled', false
        $ ".date-range input" .prop 'required', true

  set-edit-panel-value: (activity-id)!->
    activity = null

    if activity-id
      resource = window.activity.resource
      activity := resource.get-activity-data-by-id activity-id
    else
      activity :=
        title: ''
        intro: ''
        pic: ''
        date_begin: '0'
        date_end: '0'
        content: ''

    $ '#activity-name' .val activity.title
    if activity.date_begin is '0' and activity.date_end is '0'
      $ '#expiry-date' .val 0
      $ '.date-range label' .add-class 'disabled'
      $ ".date-range input" .prop 'disabled', true
      $ ".date-range input" .val ''
    else
      $ '#expiry-date' .val 1
      $ '#activity-start-date' .val activity.date_begin
      $ '#activity-end-date' .val activity.date_end
      $ '.date-range label' .remove-class 'disabled'
      $ ".date-range input" .prop 'disabled', false

    base-pic-url = 'http://static.brae.co/images/activity/'

    if activity.pic is '' or !activity.pic
      $ '#activity-image-preview' .attr 'src', ''
    else
      $ '#activity-image-preview' .attr 'src', base-pic-url + activity.pic

    $ '#activity-brief' .val activity.intro
    $ '#activity-content' .val activity.content

    $ '.activity-name .letter-number' .text get-total-num-length-of-cn-and-en-text(activity.title) + ' / 10'
    $ '.activity-brief .letter-number' .text get-total-num-length-of-cn-and-en-text(activity.intro) + ' / 40'
    $ '.activity-content .letter-number' .text get-total-num-length-of-cn-and-en-text(activity.content) + ' / 200'

  activity-list-item-init: !->
    that = @
    $ '.activity-items ul li' .click (event)!->
      id = $(@).find('.id').text!
      window.activity.current-activity-id = parse-int id
      $ '.delete-acvivity' .remove-class 'delete-acvivity-hide'
      $ '.activity-items li' .remove-class 'activity-item-background-color'
      $ @ .add-class 'activity-item-background-color'
      that.set-edit-panel-value id

  # action: /update/activity, /create/activity, /delete/activity
  # set-form-action: (action)!->
  #   $ '#activityForm' .attr 'action', action

  form-event-init: !->

    $ '#activityForm' .submit (event)->
      base64-src = $ '#activity-image-preview' .attr 'src'

      window.activity.resource.upload-image-as-base64 base64-src, (result)!->
        if result?.message is 'success'
          data = get-form-data!
          window.activity.resource.create-activity data
        else
          alert '图片上传出错'

      get-form-data = ->
        data = {}
        data-array = $ '#activityForm' .serialize-array!
        data-array.for-each (item)!->
          if item.name is 'activity-name'
            data.title = item.value
          else if item.name is 'activity-brief'
            data.intro = item.value
          else if item.name is 'activity-content'
            data.content = item.value

        data.type = window.activity.current-add-activity-type
        data.date_begin = 0
        data.date_end = 0
        data-str = JSON.stringify data

        data.JSON = data-str
        data

      event.prevent-default!

  delete-activity-init: !->
    $ '.delete-acvivity' .click (event)!->
      if confirm '你确定删除该活动吗?'

        window.activity.resource.delete-activity-by-id window.activity.current-activity-id

  # create-activity-init: !->
  #   $ '.new-promotion-activity' .click !~>
  #     if window.activity.current-data-is-dirty is false
  #       window.activity.current-add-activity-type = 'sales'
  #       $ '.delete-acvivity' .add-class 'delete-acvivity-hide'
  #       @set-edit-panel-value!

  #       console.log window.activity

  #       $ '.activity-items li' .remove-class 'activity-item-background-color'
  #       li = window.activity.resource.create-activity-item 0, '名称', '简介', ''
  #       $ li .add-class 'activity-item-background-color'
  #       $ '.reduce-activities-list' .append li

  #   $ '.new-theme-activity' .click !~>
  #     if window.activity.current-data-is-dirty is false
  #       window.activity.current-add-activity-type = 'theme'
  #       $ '.delete-acvivity' .add-class 'delete-acvivity-hide'
  #       @set-edit-panel-value!

  #       $ '.activity-items li' .remove-class 'activity-item-background-color'
  #       li = window.activity.resource.create-activity-item 0, '名称', '简介', ''
  #       $ li .add-class 'activity-item-background-color'
  #       $ '.theme-activities-list' .append li

  cancle-activity-init: (event)!->
    $ '#activity-cancle' .click !~>
      @set-edit-panel-value!

  action: ->
    @page-init!
    @upload-image-previews-init!
    @letter-number-limit-init!
    @date-range-init!
    @activity-list-item-init!
    # @form-event-init!
    @delete-activity-init!
    # @create-activity-init!
    @cancle-activity-init!

    console.log 'Activity controller action!'

module.exports = Controller
