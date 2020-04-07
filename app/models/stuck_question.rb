class StuckQuestion < ApplicationRecord
	has_many	:stuck_answers
	accepts_nested_attributes_for :stuck_answers, reject_if: :all_blank, allow_destroy: true

	def question_with_number
		"#{self.sort}. #{self.question}"
	end

	def form_parameter
		"question_#{self.id}"
	end
end