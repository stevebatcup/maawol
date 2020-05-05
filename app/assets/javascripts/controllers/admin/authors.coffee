class Maawol.AdminAuthorsController extends Maawol.AdminPage

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
		if $('.field-unit__field.image').length > 0
			@initializeUploader 'author', 'image', 'image_preview'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminAuthorsController', Maawol.AdminAuthorsController)