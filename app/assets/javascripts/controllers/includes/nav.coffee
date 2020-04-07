class Maawol.Nav extends Maawol.Page

	@register window.App
	@$inject: [
		'$scope'
		'$element'
		'$timeout'
	]

	init: ->
		@isSignedIn = !!@element.data('signed-in')
		unless @isSignedIn
			hash = window.location.hash
			if (hash.length > 0) and (hash.indexOf('#!#') > -1)
				strippedUri = hash.substring(2)
				@navigateUri(null, strippedUri)

	navigateUri: ($event=null, uri) =>
		$event.preventDefault() if $event
		@closeMenu()
		if uri.indexOf('#') > -1
			if window.location.pathname is '/'
				pos = $(uri).position().top
				$(window).scrollTop pos
			else
				window.location.href = "/#{uri}"
		else
			window.location.href = uri

	closeMenu: ($event=null) =>
		$('.navbar-toggle', '.header-top').click() if $('.header-bottom').hasClass('show')

Maawol.ControllerModule.controller('NavController', Maawol.Nav)