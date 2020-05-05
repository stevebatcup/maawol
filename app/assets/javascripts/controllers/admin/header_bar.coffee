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
			$('#admin_sidenav').addClass('hidden')

	toggleSideMenu: ($event) =>
		$event.preventDefault()
		$('#admin_sidenav').toggleClass('hidden')
		@timeout =>
			status = if $('#admin_sidenav').hasClass('hidden') then 1 else 0
			@cookies.set('sidenav_closed', status)


Maawol.ControllerModule.controller('AdminHeaderBarController', Maawol.AdminHeaderBarController)