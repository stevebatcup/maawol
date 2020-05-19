class Maawol.AdminContentManagementContentBlocksController extends Maawol.AdminPage

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
		if $('.field-unit__field.audio').length > 0
			@initializeUploader 'audio_file', 'audio_file', 'player'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminContentManagementContentBlocksController', Maawol.AdminContentManagementContentBlocksController)