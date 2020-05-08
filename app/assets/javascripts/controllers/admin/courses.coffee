class Maawol.AdminCoursesController extends Maawol.AdminPage

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
			@initializeUploader 'course', 'image', 'image'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminCoursesController', Maawol.AdminCoursesController)