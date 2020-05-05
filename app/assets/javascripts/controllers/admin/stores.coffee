class Maawol.AdminStoresController extends Maawol.AdminPage

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
		@initTinyMce()
		@bindEvents()

	bindEvents: ->

Maawol.ControllerModule.controller('AdminStoresController', Maawol.AdminStoresController)