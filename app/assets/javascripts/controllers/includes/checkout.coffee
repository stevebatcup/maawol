class Maawol.Checkout

	bindPaymentForm: =>
		$(document).on 'click', 'button.pay_btn', (e) =>
			e.preventDefault()
			@scope.$apply =>
				@submitPayment(e)

	submitPayment: (e) =>
		if @scope.payment.type is 'paypal'
			@processPayment $(e.currentTarget)
		else
			@validateCardDetails @scope.payment, =>
				@processPayment $(e.currentTarget)

	processPayment: ($clicked) =>
		$form = $clicked.closest('form')
		@scope.paying = true
		$clicked = $form.find('#pay_btn')
		url = $form.attr('action')
		paymentData =
			payment: @scope.payment
		if 'subscription' of @scope
			paymentData["users_subscription"] =
				level: @scope.subscription.level
		@timeout =>
			@http.post(url, paymentData).then (response) =>
				if response.data.status is 'error'
					@paymentError response.data.error
				else
					@paymentSuccess(response)
			, (error) =>
				@paymentError error.statusText
		, 1250

	validateCardDetails: (cardData, success) =>
		if ('firstName' of cardData) and (cardData.firstName.length is 0)
			msg = @element.data('card-error-name-invalid')
			@cardDetailsError(msg)
		else if ('lastName' of cardData) and (cardData.lastName.length is 0)
			msg = @element.data('card-error-name-invalid')
			@cardDetailsError(msg)
		else if ('email' of cardData) and !Maawol.FormHelpers.validEmail(cardData.email)
			msg = @element.data('card-error-email-invalid')
			@cardDetailsError(msg)
		else if cardData.cardNumber.length < 16
			msg = @element.data('card-error-number-invalid')
			@cardDetailsError(msg)
		else if (cardData.expiry.month is 0) or (cardData.expiry.year is 0)
			msg = @element.data('card-error-expiry-invalid')
			@cardDetailsError(msg)
		else if cardData.cv2.length < 3
			msg = @element.data('card-error-cv2-invalid')
			@cardDetailsError(msg)
		else
			success.call(@)

	cardDetailsError: (msg) =>
		@paymentError(msg)

	paymentError: (msg) =>
		@scope.paying = false
		@scope.paymentError =
			title: @element.data('payment-error-prefix')
			msg: msg
		@timeout =>
			$("#paymentErrorModal").modal()
		true

	paymentSuccess: (response) =>
		if @scope.payment.type is 'paypal'
			return window.location.href = response.data.paypalRedirect
		else
			return window.location.href = @scope.cardPaymentRedirectUrl
