class Maawol.AdminCategoriesController extends Maawol.AdminPage

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
		@initTinyMce()
		@bindEvents()

	bindEvents: ->

Maawol.ControllerModule.controller('AdminCategoriesController', Maawol.AdminCategoriesController)