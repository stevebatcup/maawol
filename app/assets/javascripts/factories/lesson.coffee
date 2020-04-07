Maawol.FactoryModule.factory("Lesson", ['RailsResource',
  (RailsResource) ->
    class Lesson extends RailsResource
      @configure
        url: '/lessons'
        name: 'lesson'
        interceptAuth: true
])