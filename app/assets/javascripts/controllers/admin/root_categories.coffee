class Maawol.AdminRootCategoriesController extends Maawol.AdminPage

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
	]

	init: ->
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@initSelectize()
		@bindEvents()

	bindEvents: ->

Maawol.ControllerModule.controller('AdminRootCategoriesController', Maawol.AdminRootCategoriesController)