class Maawol.FormHelpers

	@checkFormForBlanks: (form) ->
	  hasBlanks = []
	  form.find('input[type=text], input[type=email], input[type=number], input[type=password], input[type=date], select').each (index, field) =>
	    $field = $(field)
	    if $field.is(':visible') and @isBlank($field.val())
	      hasBlanks.push $field unless $field.hasClass('not-required')
	  if _.size(hasBlanks) is 0 then false else hasBlanks

	@isBlank: (value) ->
	  parseInt(value) is 0 or value is ''

	@getUrlVars: ->
		vars = {}
		parts = window.location.href.replace /[?&]+([^=&]+)=([^&]*)/gi, (m,key,value) ->
			vars[key] = value
		return vars

	@capitaliseWords: (string) ->
		return string.replace /(?:^|\s)\S/g, (a) ->
			a.toUpperCase()

	@markFieldWithError: ($field, msg=null) ->
		$wrapper = $field.closest('.field')
		$wrapper.find('p.error_msg').remove().end().addClass('has_error')
		unless msg is null
			$errorText = $('<p class="error_msg">').text(msg)
			$wrapper.append($errorText)

	@clearErrorsFromFields: ($form) ->
		$form.find('.field.has_error').each (index, field) ->
			$(field).removeClass('has_error').find('.error_msg').remove()

	@validEmail: (email) ->
		pattern = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
		pattern.test email

	@validPhone: (phone) ->
		pattern = /^(((\+44)? ?(\(0\))? ?)|((\+353)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}$/
		pattern.test phone

	@validUKPostcode: (postcode) ->
		postcode = postcode.toUpperCase()
		pattern = /[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}/
		pattern.test postcode

	@fancyCheckboxChecked: ($field) ->
		$field.is(':checked')
