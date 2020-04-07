class Maawol.MobileSubscriptions extends Maawol.Subscriptions

	init: ->
		super
		@scope.slide = 'options'

	bindEvents: =>
		super

		$(document).on 'click', '#back_to_options', (e) =>
			e.preventDefault()
			@scope.$apply =>
				@scope.slide = 'options'

	setDefaultLevel: (level) =>
		false

	discountApplied: (options, code, fromForm=false) =>
		if fromForm
			window.location.reload()
		else
			@scope.subscription_options = options
			@scope.discount.description = @sce.trustAsHtml(@element.data('discount-applied-text').replace('%{code}', "<b>#{code}</b>"))

	selectOption: (level) ->
		super(level)
		@timeout =>
			@scope.slide = 'payment'
		, 350

Maawol.ControllerModule.controller('MobileSubscriptionsController', Maawol.MobileSubscriptions)