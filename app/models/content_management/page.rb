module ContentManagement
	class Page < ApplicationRecord
		has_many	:sections
		has_many	:content_blocks, through: :sections

	  accepts_nested_attributes_for :sections, :allow_destroy => true
	  accepts_nested_attributes_for :content_blocks

		before_create	:default_is_editable
		validates_presence_of	:title
		validates :sections, length: { :minimum => 1, message: I18n.t("errors.messages.page_needs_blocks") }
		before_save :set_slug

		def self.table_name
			'cms_pages'
		end

		def self.footer_navbar_items
			self.where.not(slug: [nil, ""])
		end

		def url
			"/#{slug}"
		end

		def meta_description
			if self.content_blocks.empty?
				self.content_blocks.first.content
			else
				''
			end
		end

	private

		def default_is_editable
			self.is_editable = true if is_editable.nil?
		end

		def set_slug
			self.slug = title.downcase.parameterize
		end
	end
end