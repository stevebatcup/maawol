class Teaching < ApplicationRecord
	belongs_to :course, optional: true
	belongs_to :lesson
	accepts_nested_attributes_for :lesson, :reject_if => :all_blank
end