class RootCategory < ApplicationRecord
	has_many	:categories
  before_save :set_slug

	def url
		"/lessons/section/#{slug}/all"
	end

private

  def set_slug
    self.slug = self.name.parameterize
  end
end
