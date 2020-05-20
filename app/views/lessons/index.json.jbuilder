if @error
	json.error @error
else
	json.set! :total, @total if @total
	json.set! :items do
		json.array! @lessons do |lesson|
			json.id lesson.id
			json.author do
				json.name lesson.author.name
				json.avatar lesson.author.avatar.url(:thumbnail)
			end
			json.name lesson.name
			json.image lesson.listing_thumbnail_path
			json.hasThumbnail lesson.thumbnail.present?
			json.category lesson.categories.first.name if lesson.categories.any?
			json.published t('views.lesson.meta.published_at', at: time_ago_in_words(lesson.publish_date)).capitalize

			if lesson.courses.any?
				course = lesson.courses.first
				json.course do
					json.path course_path(course)
					json.name course.name
				end
				available = signed_in? ? lesson.available_for_user?(current_user) : can_access_full_course_without_account(course)
			else
				available = signed_in? ? lesson.available_for_user?(current_user) : false
			end

			json.available available
			json.path available ? lesson_path(id: lesson.slug) : locked_lesson_redirect_path
		end
	end
end