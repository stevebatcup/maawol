class Maawol.Dashboard extends Maawol.Page

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
		$(".owl-carousel").owlCarousel
			stagePadding: 10
			loop: false
			nav: false
			dots: true
			responsive:
				0:
					items:1
				900:
					items:2
		@bindEvents()

	bindEvents: =>
		super

Maawol.ControllerModule.controller('DashboardController', Maawol.Dashboard)