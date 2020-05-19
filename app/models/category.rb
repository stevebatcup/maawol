class Category < ApplicationRecord
	has_and_belongs_to_many :lessons
  has_and_belongs_to_many :courses
	belongs_to :root_category

	validates_presence_of	:name
  before_save :set_slug

private

  def set_slug
    self.slug = self.name.parameterize
  end
end