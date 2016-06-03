# 'use strict';

# ActivityView类提供单页面内伪路由控制

class View
  (options)->
    @initial = options.initial
    @views = options.views
    @views-dom = {}
    @transitions = options.transitions
    @show-state = options.show-state.join ' '
    @hide-state = options.hide-state.join ' '
    @init-state = options.init-state.join ' '
    @current-state = []

    @action!

  get-views-dom: !->
    for view in @views
      @views-dom[view] = $ view

  init-view: !->
    for view in @views
      @views-dom[view] .add-class @init-state
    for item in @initial
      @views-dom[item] .remove-class @init-state .add-class @show-state

  create-transition: (from-states, to-states, conditions)!->
    for condition in conditions
      [hook, event] = condition.split ' '

      $(hook)[event] !~>
        for from-state in from-states
          @views-dom[from-state]
            .remove-class @init-state
            .remove-class @show-state
            .add-class @hide-state

        for to-state in to-states
          @views-dom[to-state]
            .remove-class @init-state
            .remove-class @hide-state
            .add-class @show-state

        @current-state = to-states

  set-state-machine: !->
    for transition in @transitions
      @create-transition transition.from, transition.to, transition.on

  go-to-state: (states)!->
    for view in @views
      @views-dom[view] .add-class @init-state .remove-class @show-state .remove-class @hide-state
    for item in states
      @views-dom[item] .remove-class @init-state .add-class @show-state

  action: ->
    @get-views-dom!
    @init-view!
    @set-state-machine!

    console.log 'Activity view action!'

module.exports = View
