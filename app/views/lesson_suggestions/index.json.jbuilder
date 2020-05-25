json.set! :suggestions do
	json.array! @suggestions do |lesson|
		json.id lesson.id
		json.author do
			json.name lesson.author.name
		end
		json.name lesson.name
		json.image lesson.listing_thumbnail_path
		json.hasThumbnail lesson.thumbnail.present?
		json.category lesson.categories.first.name if lesson.categories.any?
		json.published t('views.lesson.meta.published_at', at: time_ago_in_words(lesson.publish_date)).capitalize

		if lesson.courses.any?
			course = lesson.courses.first
			json.course do
				json.path course_by_slug_path(slug: course.slug)
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