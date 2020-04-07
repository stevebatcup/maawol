class SiteImage < ApplicationRecord
	before_create	:generate_slug
	mount_uploader :image, SiteImageUploader

	def generate_slug
		self.slug = self.name.downcase.underscore if self.slug.nil?
	end
end