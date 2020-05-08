class Maawol.AdminDownloadablesController extends Maawol.AdminPage

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
		if $('.field-unit__field.document').length > 0
			@initializeUploader 'downloadable', 'file', 'document'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminDownloadablesController', Maawol.AdminDownloadablesController)