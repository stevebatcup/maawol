module ContentManagement
	class Image < ApplicationRecord
		mount_uploader 	:image, ContentManagement::ImageUploader

		def self.table_name
			'cms_images'
		end

		def large_url
			self.image.url(:large)
		end

		def medium_url
			self.image.url(:medium)
		end

		def small_url
			self.image.url(:small)
		end
	end
end