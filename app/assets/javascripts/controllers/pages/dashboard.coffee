class Maawol.Dashboard extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
	  '$scope'
	  '$http'
	]

	init: ->
		$(".owl-carousel").each (index, box) =>
			if $(box).find('.lesson_result').length > 0
				$(box).owlCarousel
					items: if @isMobile() then 1 else 4
					stagePadding: 10
		@bindEvents()

	bindEvents: =>
		super

Maawol.ControllerModule.controller('DashboardController', Maawol.Dashboard)