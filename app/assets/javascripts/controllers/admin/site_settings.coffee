class Maawol.AdminSiteSettingsController extends Maawol.AdminPage

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
		@initTinyMce()
		@initializeUploader 'site_setting', 'image', 'square_logo_preview'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminSiteSettingsController', Maawol.AdminSiteSettingsController)