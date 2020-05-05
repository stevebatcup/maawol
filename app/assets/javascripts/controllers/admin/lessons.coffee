class Maawol.AdminLessonsController extends Maawol.AdminPage

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
		if $('.field-unit__field.image').length > 0
			@initializeUploader 'lesson', 'image', 'image_preview'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminLessonsController', Maawol.AdminLessonsController)