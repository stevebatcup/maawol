class Maawol.Settings extends Maawol.Page

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
		@include new Maawol.Checkout()
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@bindEvents()
		@scope.card =
			type: 'visa'
			cardNumber: ''
			expiry:
				month: 0
				year: 0
			cv2: ''
		@scope.paymentError =
			title: ''
			msg: ''
		@scope.cancellingRecurringBilling = false
		@scope.deletingAccount = false
		vars = Maawol.FormHelpers.getUrlVars()
		if 'preclick' of vars
			@timeout =>
				$("a.nav-link#menu_#{vars['preclick']}").click()
			, 100

	bindEvents: =>
		@bindSubscribeCalloutClick()

		$(document).on 'click', 'a#cancel_recurring', (e) =>
			e.preventDefault()
			@cancelRecurringDialog()

		$(document).on 'click', '#deactivate', (e) =>
			e.preventDefault()
			@redirectToLessons()

		$(document).on 'click', '#cancel_recurring_confirm', (e) =>
			e.preventDefault()
			@cancelRecurringBilling(e)

		$(document).on 'shown.bs.collapse', '#update_card', (e) =>
			@timeout =>
				$('input#card_number').focus()
			, 500

		$(document).on 'click', '#update_card_btn', (e) =>
			e.preventDefault()
			@validateCardDetails @scope.card, =>
				$('form#update_card_form').submit()

	accountDeleteDialog: ($event) =>
		$event.preventDefault()
		$('#deleteAccountModal').modal()

	confirmDeleteAccount: ($event) =>
		$event.preventDefault()
		@scope.deletingAccount = true
		@timeout =>
			@http.delete("/delete-account").then (response) =>
				$('button[data-dismiss=modal]', '#deleteAccountModal').click()
				if response.data.status is 'success'
					window.location.href = "/"
				else
					@deleteAccountError(response.data.message)
			, (error) =>
				@deleteAccountError(error.statusText)
		, 750
		true

	deleteAccountError: (msg) =>
		@scope.deletingAccount = false
		msgPrefix = @element.data('account-deletion-error')
		@alert "#{msgPrefix}: #{msg}"

	cardDetailsError: (msg) =>
		@scope.$apply =>
			@scope.paymentError =
				title: @element.data('payment-error-prefix')
				msg: msg
			$("#paymentErrorModal").modal()
		true

	cancelRecurringDialog: =>
		$('#cancelRecurringAreYouSureModal').modal()

	redirectToLessons: ->
		window.location.href = "/lessons"

	cancelRecurringBilling: (e) =>
		$clicked = $(e.currentTarget)
		@scope.cancellingRecurringBilling = true
		id = $('[data-current-subscription-id]').data('current-subscription-id')
		@timeout =>
			@http.patch("/subscriptions/#{id}").then (response) =>
				$('button[data-dismiss=modal]', '#cancelRecurringAreYouSureModal').click()
				if response.data.status is 'success'
					window.location.reload()
				else
					@recurringCancellationError(response.data.message)
			, (error) =>
				@recurringCancellationError(error.statusText)
		, 750
		true

	recurringCancellationError: (msg) =>
		@scope.cancellingRecurringBilling = false
		msgPrefix = @element.data('recurring-cancellation-error')
		@alert "#{msgPrefix}: #{msg}"

Maawol.ControllerModule.controller('SettingsController', Maawol.Settings)