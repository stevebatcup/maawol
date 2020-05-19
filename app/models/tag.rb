class Tag < ApplicationRecord
	has_and_belongs_to_many :lessons
  before_save :set_slug

  def self.for_cloud
  	where(show_in_cloud: true).order("RANDOM()").limit(20)
  end

private

  def set_slug
    self.slug = self.name.parameterize
  end
end