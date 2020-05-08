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
		@initializeUploader 'site_setting', 'square_logo', 'image'
		@initializeUploader 'site_setting', 'landscape_logo', 'image'
		@initializeUploader 'site_setting', 'favicon', 'image'
		@initializeUploader 'site_setting', 'contact', 'image'
		@initializeUploader 'site_setting', 'email_banner', 'image'

	bindEvents: ->

Maawol.ControllerModule.controller('AdminSiteSettingsController', Maawol.AdminSiteSettingsController)