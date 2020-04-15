class SiteSetting < ApplicationRecord
	after_save	:bust_cache

	def bust_cache
		Rails.cache.delete("site_settings")
	end

	def self.site_admin_gets_new_registration_email?
		find_by(name: "Receives new-registration admin email").value == 'yes'
	end

	def self.site_admin_gets_new_subscription_email?
		find_by(name: "Receives new-subscription admin email").value == 'yes'
	end

	def self.site_admin_gets_subscription_cancelled_email?
		find_by(name: "Receives subscription-cancelled admin email").value == 'yes'
	end

	def self.site_admin_gets_failed_payment_email?
		find_by(name: "Receives failed-payment admin email").value == 'yes'
	end

	def self.editable
		where(is_editable: true)
	end

	def self.get_profit_split_percentage
		find_by(name: "Owner profit split percentage").value.to_i
	end
end