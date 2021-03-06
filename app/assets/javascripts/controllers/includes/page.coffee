class Maawol.Page extends Maawol.NGController
	constructor: ->
		super
		if !!$('body').data('requires-cookie-permissions')
			@timeout =>
				@showCookieNotice()
				@bindCookieAcceptance()
			, 1000

	showCookieNotice: =>
		$('#cookie-notice').show()

	bindCookieAcceptance: =>
		$('#cn-accept-cookie').on 'click', (e) =>
			e.preventDefault()
			$.getJSON '/cookie-acceptance', (response) =>
				if response.status is 'success'
					$('#cookie-notice').fadeOut()
					$('body').removeClass('show_cookie_notice')
				else
					@cookieAcceptanceError()
			.fail (error) =>
				@cookieAcceptanceError()

	cookieAcceptanceError: =>
		@alert "Sorry there has been an error. Please try again.", "Error"

	isMobile: ->
		$('body').hasClass('mobile') and $(window).width() < 900

	bindEvents: =>
		@fixHeaderOnScroll() if @canFixScrollingHeader()

		if @isMobile()
			$('.menu-item-has-children > a').on 'click', (e) =>
				$('li.menu-item').removeClass('active')
				e.preventDefault()
				e.stopPropagation()
				$clicked = $(e.currentTarget)
				$clicked.parent().siblings().removeClass('open')
				$clicked.parent().toggleClass('open')

	canFixScrollingHeader: =>
		!@isMobile() && $('header .header-bottom').length

	bindSubscribeCalloutClick: =>
		$(document).on 'click', '#subscribe_instructions', =>
			@redirectTo '/subscribe'

	fixHeaderOnScroll: =>
		headerStartPosition = $('header .header-bottom').position().top + 30
		$(window).on 'scroll', (e) =>
			isFixed = $(window).scrollTop() >= headerStartPosition
			$('header .header-bottom').toggleClass('fixed', isFixed)
			$('.yield_wrapper').toggleClass('has-fixed-header', isFixed)

	scrollToElement: ($element, extraOffset=0) =>
		@scrollTo ($element.position().top + extraOffset)

	scrollTo: (offset, callback=null) =>
		$('body, html').stop().animate
			scrollTop: offset
		, 1000
		if callback
			setTimeout =>
				callback.call(@)
			, 200

	lockedLessonClick: ($event) =>
		$event.preventDefault()
		@redirectTo @element.data("redirect-locked-lessons")

	postJSON: (url, data, successCallback=null, errorCallback=null) =>
		$.ajax
			url: url,
			type: 'POST'
			dataType: 'json'
			data: data
			success: (response) =>
				if response.result is 'success'
					successCallback.call(@, response) if successCallback?
				else
					errorCallback.call(@, response) if errorCallback?
			error: (response) =>
				errorCallback.call(@, response) if errorCallback?

	deleteJSON: (url, successCallback=null, errorCallback=null) =>
		$.ajax
			url: url,
			type: 'DELETE'
			dataType: 'json'
			success: (response) =>
				if response.result is 'success'
					successCallback.call(@, response) if successCallback?
				else
					errorCallback.call(@, response) if errorCallback?
			error: (response) =>
				errorCallback.call(@, response) if errorCallback?

	getDocumentHeight: ->
		scroll = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight)
		offset = Math.max(document.body.offsetHeight, document.documentElement.offsetHeight)
		client = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
		Math.max(scroll, offset, client)

	setDefaultHttpHeaders: ->
		@http.defaults.headers.common['Accept'] = 'application/json'
		@http.defaults.headers.common['Content-Type'] = 'application/json'

	setCsrfTokenHeaders: ->
		@http.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

	getBasket: (callback=null) =>
		@http.get("/basket").then (response) =>
			if response.data.status is 'success'
				angular.forEach response.data.items, (item) =>
					@scope.basket.items.push { product: item.product, quantity: item.quantity }
				@scope.basket.total = response.data.total
				@scope.basket.store = response.data.store if 'store' of response.data
				@scope.basket.loaded = true
			else
				@alert response.data.message
			callback.call(@) if callback?

	alert: (msg) =>
		alert msg

	refreshPage: =>
		window.location.reload()

	redirectTo: (url) =>
		window.location.href = url
