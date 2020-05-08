class Maawol.AdminAudioFilesController extends Maawol.AdminPage

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
		if $('.field-unit__field.audio').length > 0
			@initializeUploader 'audio_file', 'file', 'audio_file'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminAudioFilesController', Maawol.AdminAudioFilesController)