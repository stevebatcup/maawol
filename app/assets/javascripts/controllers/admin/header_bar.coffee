class Maawol.AdminHeaderBarController extends Maawol.AdminPage

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'cookies'
	]

	init: ->
		@initSideMenu()

	initSideMenu: =>
		if parseInt(@cookies.get('sidenav_closed')) is 1
			$('.app-container').addClass('nav_hidden')

	toggleSideMenu: ($event) =>
		$event.preventDefault()
		$('.app-container').toggleClass('nav_hidden')
		@timeout =>
			status = if $('.app-container').hasClass('nav_hidden') then 1 else 0
			@cookies.set('sidenav_closed', status, { path: "/admin" })


Maawol.ControllerModule.controller('AdminHeaderBarController', Maawol.AdminHeaderBarController)