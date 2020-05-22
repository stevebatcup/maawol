class SiteSetting < ApplicationRecord
	after_save	:bust_cache
  before_save :set_slug

  def set_slug
    self.slug = self.name.parameterize
  end

	def bust_cache
		Rails.cache.delete("school_settings")
	end

	def self.site_admin_gets_new_registration_email?
		find_by(slug: "receives-new-registration-admin-email").value == 'yes'
	end

	def self.site_admin_gets_new_subscription_email?
		find_by(slug: "receives-new-subscription-admin-email").value == 'yes'
	end

	def self.admin_email_address
	  find_by(slug: "contact-email-address").value
	end

	def self.site_admin_gets_subscription_cancelled_email?
		find_by(slug: "receives-subscription-cancelled-admin-email").value == 'yes'
	end

	def self.site_admin_gets_failed_payment_email?
		find_by(slug: "receives-failed-payment-admin-email").value == 'yes'
	end

	def self.editable
		where(is_editable: true)
	end

	def self.get_profit_split_percentage
		find_by(slug: "owner-profit-split-percentage").value.to_i
	end

	def self.theme_options
		['light-green','light-blue','light-red','dark-green','dark-blue','dark-red']
	end
end