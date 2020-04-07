Maawol.FactoryModule.factory("Comment", ['RailsResource',
  (RailsResource) ->
    class Comment extends RailsResource
      @configure
        url: '/comments'
        name: 'comment'
        interceptAuth: true
])