class LessonSuggestionsController < MaawolController
	def index
		limit = (params[:limit] || 10).to_i
		@suggestions = []
		@master_lesson = Lesson.find(params[:id])
		@suggestions = @master_lesson.recommendation_lessons.limit(limit).to_a

		if @suggestions.length < limit
			@master_lesson.categories.each do |category|
				ids = @suggestions.map(&:id)
				category.lessons.where.not(lessons: { id: @master_lesson.id }).each do |lesson|
					break if @suggestions.length == limit
					@suggestions << lesson unless ids.include?(lesson.id)
				end
			end
		end
	end
end