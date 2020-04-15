module ContentManagement
	class NavbarItem < ApplicationRecord
		belongs_to	:navbar
		default_scope { order(sort: :asc) }

		def self.table_name
			'cms_navbar_items'
		end

		def slug
			self.name.downcase.underscore.to_sym
		end

		def can_be_seen_by_user(user)
			true
		end
	end
end