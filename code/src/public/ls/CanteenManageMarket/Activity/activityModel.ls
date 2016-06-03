# 'use strict';

# ActivityModel类，利用localStorage存储数据，实现MV之间的双向数据绑定
# Model实现双向数据绑定需要较为复杂的设计，由于目前时间紧迫，而且我还没完全想清楚实现方式
# 暂时利用controller用传统的方法实现应有的功能，有时间的情况下再研究Model的双向数据绑定特性
#
# 设计：
# $scope: Model实例变量，用来存储model变量
# model变量: 具有双向数据绑定能力，在$scope内定义，能映射到DOM中的具体的值
# a-model指令: 将具有输入特性的DOM元素绑定到model变量
# a-bind指令: 将model变量绑定到没有输入特性的DOM元素
# a-repeat指令: 能将$scope数据循环渲染在DOM元素中
# a-src指令: 能绑定model变量，将变量值变成a元素的src属性的值

class Model
	->
		@$scope = {}

		@a-models = []
		@a-binds = []

		@action!

	set-a-model: !->

	get-a-model: !->

	collect-models: !->

	collect-binds: !->

	action: !->
		@collect-models!
		@collect-binds!

		console.log 'Activity model action! But not yet realized!'

module.exports = Model
