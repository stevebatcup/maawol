class Maawol.Admin extends Maawol.Page

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
		@scope.settingHomepageVideo = false

	initSelectize: =>
		$(".field-unit--attachable-field select").selectize({});
		$(".field-unit--has-lots-field select").selectize({});

	initTinyMce: =>
		tinymce.init
			selector: "textarea.tinymce"
			plugins: "link image code"
			image_advtab: true
			image_uploadtab: true
			image_class_list: [
				{ title: 'Align Left', value: 'align_left' }
				{ title: 'Align Right', value: 'align_right' }
			]
			toolbar: [
				"h1 h2 h3 | bold italic underline strikethrough | link unlink image code"
				"alignleft aligncenter alignright alignjustify | undo redo | formatselect"
			]

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

	resetColor: ($event, inputId, defaultColor) =>
		$event.preventDefault()
		$("##{inputId}").val defaultColor

	resetAllColors: ($event) =>
		$event.preventDefault()
		@timeout =>
			$('a.reset_color').click()
			@timeout =>
				$('#update_colors').click()
			, 1
		, 1
		true

Maawol.ControllerModule.controller('AdminController', Maawol.Admin)