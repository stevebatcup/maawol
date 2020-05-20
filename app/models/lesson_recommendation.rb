class LessonRecommendation < ApplicationRecord
	belongs_to	:recommender, foreign_key: :recommender_lesson_id, class_name: 'Lesson'
	belongs_to	:recommended, foreign_key: :recommended_lesson_id, class_name: 'Lesson'
end
