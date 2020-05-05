class SiteImage < ApplicationRecord
  include Maawol::Models::Concerns::TmpUploadable

	before_create	:generate_slug
	mount_uploader :image, SiteImageUploader
  after_save	:migrate_file_from_tmp_upload, if: -> { self.tmp_media_id.present? }

	def field_for_upload
		:image
	end

	def generate_slug
		self.slug = self.name.downcase.underscore if self.slug.nil?
	end

	def self.email_banner_url
		find_by(slug: :email_banner).image.url(:large_landscape)
	end
end