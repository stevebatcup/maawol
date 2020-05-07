module ContentManagement
	class Navbar < ApplicationRecord
		has_many	:navbar_items, :dependent => :destroy
		accepts_nested_attributes_for :navbar_items, reject_if: :all_blank, allow_destroy: true
		validate :cannot_have_too_many_items_on_desktop, on: :update
		after_save	:bust_cache

		NAVBAR_ITEM_LIMIT = 6

		def self.table_name
			'cms_navbars'
		end

		def sorted_navbar_items_for_device_type(type=:mobile)
			navbar_items.where("#{type}": true).order(sort: :asc)
		end

		def cannot_have_too_many_items_on_desktop
			if navbar_items.map(&:desktop).count(true) > NAVBAR_ITEM_LIMIT
				errors.add(:navbar_items, ": cannot select more than #{NAVBAR_ITEM_LIMIT} for desktop/tablet devices")
			end
		end

		def bust_cache
			Rails.cache.delete("footer_navbar")
		end
	end
end