class Maawol.Subscriptions extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$http'
		'$element'
		'$timeout'
		'$compile'
		'$sce'
	]

	init: ->
		@scope.cardPaymentRedirectUrl = "/lessons?paid=1"
		@include new Maawol.Checkout()
		@scope.subscription_options = []
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@bindRedirectedMessage()
		@scope.total = 0.00
		@scope.dailyPrice = 0.00
		@scope.paying = false
		@scope.paymentError =
			title: ''
			msg: ''
		@scope.discount =
			code: ''
			applied: false
			description: ''
		@scope.subscription =
			level: ''
			name: ''
			price: ''
			discounted:
				percentage: ''
				price: ''
		@scope.payment =
			type: 'visa'
			cardNumber: ''
			expiry:
				month: 0
				year: 0
			cv2: ''
		@watchSubscriptionSelect()
		@setupSubscriptionOptions()
		@bindEvents()

	applyDiscountCode: (fromForm=false) =>
		code = "#{@scope.discount.code}"
		@scope.discount.applied = true
		@scope.discount.description = @sce.trustAsHtml(@element.data('discount-applying-text').replace('%{code}', "<b>#{code}</b>"))
		data =
			apply_discount_code: code.trim()
		timeoutDelay = if e? then 1250 else 1
		@timeout =>
			@http.post("/subscription_discount", data).then (response) =>
				if response.data.status is 'success'
					@discountApplied(response.data.discount.subscriptionOptions, response.data.discount.code, fromForm)
				else
					@discountError(response.data.message)
			, (error) =>
				@discountError(error.statusText)
		, timeoutDelay

	discountApplied: (options, code, fromForm) =>
		@scope.subscription_options = options
		@scope.subscription.level = @scope.subscription_options[0].level
		@scope.discount.description = @sce.trustAsHtml(@element.data('discount-applied-text').replace('%{code}', "<b>#{code}</b>"))
		@timeout =>
			@selectOption(@scope.subscription.level, false)
		, 1

	discountError: (msg) =>
		@scope.discount.applied = false
		msgPrefix = @element.data('discount-error-prefix')
		alert "#{msgPrefix}: #{msg}"

	watchSubscriptionSelect: ->
		@scope.$watch 'subscription.level', (newVal, oldVal) =>
			@selectOption(newVal) if Number(newVal) > 0

	selectOption: (level) ->
		data = $("label[data-level=#{level}]").data()
		@scope.subscription.level = level
		@scope.subscription.name = data.name
		@scope.subscription.price = parseFloat(data.price).toFixed(2)
		@scope.subscription.fullPrice = parseFloat(data.fullPrice).toFixed(2)
		@scope.subscription.discounted.price = parseFloat(data.discountedPrice).toFixed(2)
		@scope.subscription.discounted.percentage = data.discountedPercentage
		@calculateTotals(parseFloat(data.price), parseFloat(data.monthlyPrice))

	bindEvents: =>
		@bindOptionButtons()
		@bindDiscountForm()
		@bindPaymentForm()

	bindDiscountForm: =>
		$(document).on 'click', 'button#discount_code_button', (e) =>
			e.preventDefault()
			if @scope.discount.code.length is 0
				alert "Please enter a discount code"
			else
				@scope.$apply =>
					@applyDiscountCode(true)

	bindOptionButtons: =>
		$(document).on 'click', 'button.selector', (e) =>
			e.preventDefault()
			@updateSelected $(e.currentTarget).data('level')

	setDefaultLevel: (level) =>
		@scope.subscription.level = level

	setupSubscriptionOptions: ->
		isMigration = @element.data('migration')
		url = if isMigration then "/subscription_options?migration=1" else "/subscription_options"
		@http.get(url).then (response) =>
			@scope.subscription_options = response.data.subscriptionOptions
			@timeout =>
				@setDefaultLevel(if isMigration then @scope.subscription_options[0].level else response.data.selectedLevel)
				if @element.data('discount-code').toString().length
					@timeout =>
						@scope.discount.code = @element.data('discount-code')
						@applyDiscountCode(false)
					, 150
			, 150
		, (error) =>
			msgPrefix = @element.data('server-error-options')
			alert "#{msgPrefix}: #{error.statusText}"

	updateSelected: (level) =>
		@scope.$apply =>
			@scope.subscription.level = level

	calculateTotals: (fullPrice, monthlyPrice) =>
		@scope.total = fullPrice.toFixed(2)
		@scope.dailyPrice = (monthlyPrice / 30).toFixed(2)
		@scope.dailyPriceText = @element.data('daily-calculation-text').replace('%{dailyPrice}', @scope.dailyPrice)

	bindRedirectedMessage: ->
		from = @element.data('redirected-from')
		@timeout =>
			@flash @element.data("redirected-message-#{from}") if from.length > 0
		, 500

Maawol.ControllerModule.controller('SubscriptionsController', Maawol.Subscriptions)