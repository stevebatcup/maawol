class Maawol.CheckoutPage extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'Product'
	]

	init: ->
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@scope.cardPaymentRedirectUrl = "/checkout-complete"
		@include new Maawol.Checkout()
		@scope.basket =
			items: []
			total: 0.00
			loaded: false
			store:
				url: ''
				name: ''
		@scope.payment =
			email: ''
			firstName: ''
			lastName: ''
			type: @element.data('preselected-payment-type') || 'visa'
			cardNumber: ''
			expiry:
				month: 0
				year: 0
			cv2: ''
		@bindEvents()
		@getBasket()

	bindEvents: =>
		@bindPaymentForm()

Maawol.ControllerModule.controller('CheckoutPageController', Maawol.CheckoutPage)