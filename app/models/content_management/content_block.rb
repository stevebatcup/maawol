module ContentManagement
	class ContentBlock < ApplicationRecord
		has_many	:sections
		has_many	:pages, through: :sections
		before_create	:default_as_editable

		def default_as_editable
			self.is_editable = true
		end

		def self.table_name
			'cms_content_blocks'
		end
	end
end