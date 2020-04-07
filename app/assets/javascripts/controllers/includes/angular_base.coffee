Maawol.mixOf = (base, mixins...) ->
	class Mixed extends base
	for mixin in mixins by -1 # earlier mixins override later ones
		for name, method of mixin::
			Mixed::[name] = method
	Mixed

class Maawol.NGObject
	constructor: (dependencies...) ->
		for dependency, index in @constructor.$inject
			@[dependency.replace('$', '')] = dependencies[index]
		@init?()

class Maawol.NGController extends Maawol.NGObject
	moduleKeywords = ['extended', 'included']

	@register: (app) ->
		app.controller "#{@name}", this

	constructor: (@scope) ->
		@scope[key] = value for key, value of this when !@scope[key]?
		super

	include: (obj) ->
		for key, value of obj when key not in moduleKeywords
			@[key] = value
		obj.extended?.apply(@)
		for dependency, index in @constructor.$inject
			name = dependency.replace('$', '')
			obj[name] = @[name]
		this

class Maawol.NGService extends Maawol.NGObject
	@register: (app) -> app.service "#{@name}", this

	observableCallbacks: {}

	on: (event_name, callback) ->
		@observableCallbacks[event_name] ?= []
		@observableCallbacks[event_name].push callback

	notify: (event_name, data = {}) ->
		angular.forEach @observableCallbacks[event_name], (callback) ->
			callback(data)