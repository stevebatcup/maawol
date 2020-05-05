class Maawol.Courses extends Maawol.Page

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

	bindEvents: =>
		super
		@bindSubscribeCalloutClick()

	openLesson: ($event, lessonSlug, courseId, sort, available=true, token='') =>
		$event.preventDefault()
		if available
			window.location.href = "/lessons/#{lessonSlug}?from_course=#{courseId}&lesson_index=#{sort}&token=#{token}"
		else
			@alert @element.data('lesson-locked-msg'), "Sorry..."

Maawol.ControllerModule.controller('CoursesController', Maawol.Courses)