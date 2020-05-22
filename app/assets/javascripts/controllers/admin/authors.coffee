class Maawol.AdminAuthorsController extends Maawol.AdminPage

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'$compile'
		'$sce'
	]

	init: ->
		super
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@initSelectize()
		@bindEvents()
		@scope.settingMainAuthor = false
		if $('.field-unit__field.image').length > 0
			@initializeUploader 'author', 'avatar', 'image'

	bindEvents: ->

	updateMainAuthor: ($event, authorId) =>
		$event.preventDefault()
		return if @scope.settingMainAuthor
		@scope.settingMainAuthor = true
		@http.put("/admin/set_main_author", { id: authorId }).then (response) =>
			if response.data.status is 'success'
				@updateMainAuthorSuccess()
			else
				@updateMainAuthorError(response.data.message)
				@scope.settingMainAuthor = false
		, (error) =>
			@updateMainAuthorError(error.statusText)
			@scope.settingMainAuthor = false

	updateMainAuthorError: (msg) =>
		alert "Sorry there was an error setting this for the homepage: #{msg}"

	updateMainAuthorSuccess: =>
		window.location.reload()


Maawol.ControllerModule.controller('AdminAuthorsController', Maawol.AdminAuthorsController)