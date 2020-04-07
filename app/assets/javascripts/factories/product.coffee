Maawol.FactoryModule.factory("Product", ['RailsResource',
  (RailsResource) ->
    class Product extends RailsResource
      @configure
        url: '/products'
        name: 'product'
        interceptAuth: true
])