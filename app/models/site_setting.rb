class SiteSetting < ApplicationRecord
	after_save	:bust_cache

	def bust_cache
		Rails.cache.delete("site_settings")
	end
end