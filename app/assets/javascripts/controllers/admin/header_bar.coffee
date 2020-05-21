class Maawol.AdminHeaderBarController extends Maawol.AdminPage

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'$sce'
		'cookies'
	]

	init: ->
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@initSideMenu()
		@initHelp()

	initSideMenu: =>
		if parseInt(@cookies.get('admin_sidenav_closed')) is 1
			$('.app-container').addClass('nav_hidden')

	toggleSideMenu: ($event) =>
		$event.preventDefault()
		$('.app-container').toggleClass('nav_hidden')
		@timeout =>
			status = if $('.app-container').hasClass('nav_hidden') then 1 else 0
			@cookies.set('admin_sidenav_closed', status, { path: "/admin" })

	initHelp: =>
		@rootScope.helpData =
			loading: false
			section: null
			content: null
		@scope.$watch 'helpData.section', (newVal, oldVal) =>
			if newVal? and newVal.length
				@rootScope.helpData.loading = true
				@timeout =>
					@getHelpContent newVal
				, 400

	openHelp: ($event) =>
		$event.preventDefault()
		helpSection = $("[data-help-section]").first().data('help-section')
		@rootScope.helpData.section = helpSection
		@rootScope.helpData.loading = true
		$('#help_modal').modal()
		@timeout =>
			@getHelpContent helpSection
		, 400

	getHelpContent: (helpSection) =>
		@http.get("/admin/help?section=#{helpSection}").then (response) =>
			@rootScope.helpData.loading = false
			@rootScope.helpData.content = @sce.trustAsHtml(response.data.content)
		, (error) =>
			console.log error
			@rootScope.helpData.loading = false
			@rootScope.helpData.content = @sce.trustAsHtml("<h2 class='text-center m-5'><i class='fas fa-sad-cry mr-3'></i>Help page not found</h2>")

Maawol.ControllerModule.controller('AdminHeaderBarController', Maawol.AdminHeaderBarController)