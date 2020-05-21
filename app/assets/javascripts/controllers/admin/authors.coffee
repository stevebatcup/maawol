class Maawol.AdminAuthorsController extends Maawol.AdminPage

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'$compile'
		'$sce'
	]

	init: ->
		super
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@initSelectize()
		@bindEvents()
		if $('.field-unit__field.image').length > 0
			@initializeUploader 'author', 'avatar', 'image'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminAuthorsController', Maawol.AdminAuthorsController)