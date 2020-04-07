class Maawol.HomePage extends Maawol.Page
	constructor: ->
		@bindEvents()

	bindEvents: =>
		super

Maawol.ControllerModule.controller('HomePageController', Maawol.HomePage)