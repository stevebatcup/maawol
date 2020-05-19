
class Maawol.SignUp extends Maawol.Page

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
		@scope.formValues =
			firstName: ''
			lastName: ''
			email: ''
			emailConfirm: ''
			password: ''
		@initFormErrors()
		@bindEvents()

	bindEvents: =>
		$("#register_form").on("ajax:before", (e) =>
			@initFormErrors()
			@validateForm =>
				e.preventDefault()
				@timeout =>
					$button = $(e.currentTarget).find('[data-disable-with]')[0]
					Rails.enableElement($button)
				, 750
		).on("ajax:success", (e) =>
			[responseData, status, xhr] = e.detail
			@formSuccess(responseData)
		).on "ajax:error", (e) =>
			@formError(e)

	initFormErrors: =>
		@scope.formErrors =
			base: null
			firstName: null
			lastName: null
			email: null
			emailConfirm: null
			password: null

	validateForm: (errorCallback) =>
		errors = {}
		vals = @scope.formValues
		if vals.firstName.length < 1
			errors['firstName'] = @element.data('errors-first-name')
		else if vals.lastName.length < 1
			errors['lastName'] = @element.data('errors-last-name')
		else if vals.email.length < 1
			errors['email'] = @element.data('errors-email')
		else if vals.emailConfirm.length < 1
			errors['emailConfirm'] = @element.data('errors-email-confirm')
		else if vals.emailConfirm isnt vals.email
			errors['emailConfirm'] = @element.data('errors-email-match')
		else if vals.password.length < 1
			errors['password'] = @element.data('errors-password')
		else if vals.password.length < 8
			errors['password'] = @element.data('errors-password-minimum')

		if Object.entries(errors).length > 0
			@scope.$apply =>
				angular.forEach errors, (value, key) =>
					@scope.formErrors[key] = value
			errorCallback.call(@)

	formSuccess: (responseData) =>
		if responseData.status == 'success'
			window.location.href = responseData.redirect
		else
			@scope.$apply =>
				@scope.formErrors[responseData.field] = responseData.message

	formError: (e) =>
		@scope.$apply =>
			@scope.formErrors.base = "Error sending registration form"

Maawol.ControllerModule.controller('SignUpController', Maawol.SignUp)