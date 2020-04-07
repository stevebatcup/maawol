module ContentManagement
	class Section < ApplicationRecord
		belongs_to	:page, optional: true
		belongs_to	:content_block
		accepts_nested_attributes_for :content_block, :reject_if => :all_blank

		def self.table_name
			'cms_sections'
		end
	end
end