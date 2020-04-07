class Contact < ApplicationRecord
	after_create	:send_email
	validates_presence_of	:name, :email
	before_save	:set_message
	attr_accessor	:message_as_hash, :from_home

	def send_email
		if self.message_as_hash.nil?
			ContactMailer.contact(self).deliver_now
		else
			ContactMailer.stuck(self).deliver_now
		end
	end

	def gather_question_data(params)
		message = {}
		StuckQuestion.includes(:stuck_answers).references(:stuck_answers).each do |q|
			answer = StuckAnswer.find(params[q.form_parameter].to_i)
			message[q.question_with_number] = answer.answer
		end
		self.message_as_hash = message
	end

	def set_message
		self.message = message_as_hash.to_json unless message_as_hash.nil?
	end
end