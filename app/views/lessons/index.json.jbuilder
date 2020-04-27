if @error
	json.error @error
else
	json.set! :total, @total if @total
	json.set! :items do
		json.array! @lessons do |lesson|
			json.id lesson.id
			json.path lesson_path(id: lesson.slug)
			json.image lesson.main_video.thumbnail.url(:small) if lesson.has_video_thumbnail?
			json.name lesson.name
			json.category lesson.categories.first.name if lesson.categories.any?
			json.published time_ago_in_words(lesson.publish_date)

			if lesson.courses.any?
				course = lesson.courses.first
				json.course do
					json.path course_path(course)
					json.name course.name
				end
				json.available signed_in? ? lesson.available_for_user?(current_user) : can_access_full_course_without_account(course)
			else
				json.available signed_in? ? lesson.available_for_user?(current_user) : false
			end
		end
	end
end