# 'use strict';

# Activity类，用来管理MVC和Resource

class Activity
  (data)->
    @Model = require './activityModel.js'
    @View = require './activityView.js'
    @Controller = require './activityController.js'
    @Resource = require './activityResource.js'

    @current-activity-id = null
    @current-add-activity-type = null
    @current-data-is-dirty = false

    @action!

  init-model: !->
    @model = new @Model

  init-view: !->
    @view = new @View options =
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

  init-controller: !->
    @controller = new @Controller

  init-resource: !->
    @resource = new @Resource

  action: !->
    @init-resource!
    @init-model!
    @init-view!
    @init-controller!

module.exports = Activity
