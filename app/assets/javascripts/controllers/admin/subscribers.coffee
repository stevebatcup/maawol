class Maawol.AdminSubscribersController extends Maawol.AdminPage

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
		@bindEvents()

	bindEvents: ->

Maawol.ControllerModule.controller('AdminSubscribersController', Maawol.AdminSubscribersController)