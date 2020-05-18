
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
			errors['firstName'] = "Please enter your first name"
		else if vals.lastName.length < 1
			errors['lastName'] = "Please enter your last name"
		else if vals.email.length < 1
			errors['email'] = "Please enter your email address"
		else if vals.emailConfirm.length < 1
			errors['emailConfirm'] = "Please confirm your email address"
		else if vals.emailConfirm isnt vals.email
			errors['emailConfirm'] = "Please make sure your email address matches the confirmation"
		else if vals.password.length < 1
			errors['password'] = "Please create a password for your account"
		else if vals.password.length < 8
			errors['password'] = "Please make sure your password is at least 8 charctares long"

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