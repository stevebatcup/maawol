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
		@bindListeners()
		@initTinyMce()
		@initSuccessMessages()
		@initializeUploader 'site_setting', 'square-logo', 'image' if $('#site_setting_image_square-logo').length
		@initializeUploader 'site_setting', 'landscape-logo', 'image' if $('#site_setting_image_landscape-logo').length
		@initializeUploader 'site_setting', 'favicon', 'image' if $('#site_setting_image_favicon').length
		@initializeUploader 'site_setting', 'contact', 'image' if $('#site_setting_image_contact').length
		@initializeUploader 'site_setting', 'email-banner', 'image' if $('#site_setting_image_email-banner').length

	bindEvents: =>

	initSuccessMessages: =>
		@scope.successes =
			basic: false
			branding: false
			seo: false
			contact: false

	bindListeners: =>
		angular.element('body').on 'ajax:success', (event, data) =>
			if data.status is 'success'
				@scope.$apply =>
					$section = $("#nav-#{data.section}")
					angular.element('.previews:visible', $section).hide()
					angular.element('.add_file:hidden', $section).show()
					@scope.successes[data.section] = true
					@timeout =>
						@scope.successes[data.section] = false
					, 5000
			else
				@alert data.error

Maawol.ControllerModule.controller('AdminSiteSettingsController', Maawol.AdminSiteSettingsController)