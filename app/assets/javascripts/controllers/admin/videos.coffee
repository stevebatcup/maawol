class Maawol.AdminVideosController extends Maawol.AdminPage

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
		if $('.field-unit__field.video_field').length > 0
			@initializeUploader 'video', 'tmp_video_file', 'video'

	bindEvents: ->

	updateHomepageVideo: ($event, videoId) =>
		return if @scope.settingHomepageVideo
		$event.preventDefault()
		@scope.settingHomepageVideo = true
		@http.patch("/admin/set_homepage_video", { id: videoId}).then (response) =>
			if response.data.status is 'success'
				@updateHomepageVideoSuccess()
			else
				@updateHomepageVideoError(response.data.message)
				@scope.settingHomepageVideo = false
		, (error) =>
			@updateHomepageVideoError(error.statusText)
			@scope.settingHomepageVideo = false

	updateHomepageVideoError: (msg) =>
		alert "Sorry there was an error setting this for the homepage: #{msg}"

	updateHomepageVideoSuccess: =>
		window.location.reload()

Maawol.ControllerModule.controller('AdminVideosController', Maawol.AdminVideosController)