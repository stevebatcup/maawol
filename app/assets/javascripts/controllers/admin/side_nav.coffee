class Maawol.AdminSideNavController extends Maawol.AdminPage

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'cookies'
	]

	init: ->
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@bindEvents()
		@getResourceCounts()
		angular.forEach @getCollapsibleStatesList(), (item) =>
			$("##{item}", "#admin_sidenav").collapse('hide')

	bindEvents: =>
		@bindCollapsibleClicks()

	getResourceCounts: =>
		@scope.resourceCounts =
			loaded: false
			items: {}
		@http.get("/admin/resource-counts").then (response) =>
			@scope.resourceCounts.loaded = true
			@scope.resourceCounts.items = response.data.items

	bindCollapsibleClicks: =>
		$(document).on 'hidden.bs.collapse', '.collapse', (e) =>
			$target = $(e.currentTarget)
			id = $target.attr('id')
			sectionList = @getCollapsibleStatesList()
			sectionList.push id unless _.contains sectionList, id
			@cookies.set('admin_collapsible_states', JSON.stringify(sectionList))

		$(document).on 'shown.bs.collapse', '.collapse', (e) =>
			$target = $(e.currentTarget)
			id = $target.attr('id')
			sectionList = @getCollapsibleStatesList()
			sectionList = _.filter sectionList, (item) => id isnt item
			@cookies.set('admin_collapsible_states', JSON.stringify(sectionList))

	getCollapsibleStatesList: =>
		if @cookies.get('admin_collapsible_states') is undefined
			list = JSON.stringify(['commerce_options', 'cms_options'])
			@cookies.set('admin_collapsible_states', list)
		JSON.parse(@cookies.get('admin_collapsible_states'))

Maawol.ControllerModule.controller('AdminSideNavController', Maawol.AdminSideNavController)