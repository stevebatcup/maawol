module ContentManagement
	class Page < ApplicationRecord
		has_many	:sections
		has_many	:content_blocks, through: :sections

	  accepts_nested_attributes_for :sections, :allow_destroy => true
	  accepts_nested_attributes_for :content_blocks

		before_save	:auto_generate_slug, if: :slug_is_blank?
		before_create	:default_is_editable
		validates_presence_of	:title

		def self.table_name
			'cms_pages'
		end

		def self.footer_navbar_items
			self.where.not(slug: [nil, ""])
		end

		def default_is_editable
			self.is_editable = true if is_editable.nil?
		end

		def slug_is_blank?
			slug.nil? || (slug.length == 0 && title.downcase != 'homepage')
		end

		def auto_generate_slug
			self.slug = title.downcase.parameterize
		end

		def url
			"/#{slug}"
		end

		def meta_description
			self.content_blocks.first.content
		end
	end
end