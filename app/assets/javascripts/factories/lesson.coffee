Maawol.FactoryModule.factory("Lesson", ['RailsResource',
  (RailsResource) ->
    class Lesson extends RailsResource
      @configure
        url: '/lessons'
        name: 'lesson'
        interceptAuth: true
])
.factory("SuggestedLesson", ['RailsResource',
  (RailsResource) ->
    class SuggestedLesson extends RailsResource
      @configure
        url: '/lesson-suggestions'
        name: 'suggested_lesson'
        interceptAuth: true
])