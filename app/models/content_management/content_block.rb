module ContentManagement
	class ContentBlock < ApplicationRecord
		has_many	:sections
		has_many	:pages, through: :sections
		before_create	:default_as_editable
		before_save :set_slug

		def default_as_editable
			self.is_editable = true
		end

		def self.table_name
			'cms_content_blocks'
		end

	private

		def set_slug
			self.slug = self.name.parameterize
		end
	end
end