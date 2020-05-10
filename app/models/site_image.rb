class SiteImage < ApplicationRecord
  include Maawol::Models::Concerns::TmpUploadable

	before_create	:generate_slug
	mount_uploader :image, SiteImageUploader
  after_save	:perform_migrate_tmp_file_job, if: -> { self.image_tmp_media_id.present? }

	def fields_for_upload
		[:image]
	end

	def perform_migrate_tmp_file_job
		MigrateTmpMediaFileJob.set(wait: 5.seconds).perform_later(self)
	end

	def generate_slug
		self.slug = self.name.downcase.underscore if self.slug.nil?
	end

	def self.email_banner_url
		find_by(slug: 'email-banner').image.url(:large_landscape)
	end
end