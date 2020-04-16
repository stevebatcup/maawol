class Maawol.Store extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
		'Product'
	]

	init: ->
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@scope.products = {
			loaded: false
			items: []
		}
		@scope.basket = {
			items: []
			total: 0.00
			loaded: false
		}
		@getBasket =>
			@timeout =>
				@getProducts()
			, 750

	getProducts: =>
		@Product.query({store_id: @element.data('store_id')}).then (response) =>
			angular.forEach response.items, (item) =>
				item.inBasket = if @findProductInBasket(item) then true else false
				@scope.products.items.push item
			@scope.products.loaded = true
		, (response) =>
			@refreshPage() if response.status is 401

	clearBasket: (e) =>
		e.preventDefault()
		@http.delete("/clear_basket").then (response) =>
			if response.data.status is 'success'
				@scope.basket.items = []
				@scope.basket.total = response.data.total
				angular.forEach @scope.products.items, (item) =>
					item.inBasket =  false
			else
				@alert response.data.message

	removeFromBasket: (basketItem) =>
		@http.patch("/remove_product_from_basket", {id: basketItem.product.id, quantity: basketItem.quantity}).then (response) =>
			if response.data.status is 'success'
				product = _.find @scope.products.items, (di) =>
					di.id == basketItem.product.id
				product.inBasket = false
				@scope.basket.items = _.without(@scope.basket.items, basketItem)
				@scope.basket.total = response.data.total
			else
				@alert response.data.message

	addToBasket: (product) =>
		unless @findProductInBasket(product)
			@http.patch("/add_product_to_basket", {id: product.id}).then (response) =>
				if response.data.status is 'success'
					@scope.basket.items.push { product: product, quantity: 1 }
					@scope.basket.total = response.data.total
					product.inBasket = true
				else
					@alert response.data.message

	proceedToCheckout: (item) =>
		window.location.href = "/checkout"

	findProductInBasket: (product) =>
		_.find @scope.basket.items, (bi) =>
			bi.product.id == product.id

Maawol.ControllerModule.controller('StoreController', Maawol.Store)