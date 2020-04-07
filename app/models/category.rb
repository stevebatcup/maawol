class Category < ApplicationRecord
	has_and_belongs_to_many :lessons
	belongs_to :root_category

	validates_presence_of	:root_category_id, :name
end