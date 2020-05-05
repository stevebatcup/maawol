class Maawol.Contact extends Maawol.Page

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

	bindEvents: =>
		super
		@bindSubscribeCalloutClick()

Maawol.ControllerModule.controller('ContactController', Maawol.Contact)