class UsersSubscription < ApplicationRecord
	belongs_to	:user
	belongs_to	:subscription_option
	belongs_to	:discount_code, optional: true
	validate	:check_for_existing_recurring, on: :create
	after_create :send_receipt
  after_create  :send_admin_subscription_email
  after_create  :update_mailchimp

	attr_accessor	:length

	def is_immediate
		self.created_at.strftime("%d/%m/%Y") == self.starts_at.strftime("%d/%m/%Y")
	end

	def check_for_existing_recurring
		if self.class.where(user_id: self.user_id, status: :recurring).any?
			self.errors.add(:base, I18n.t('views.subscription.errors.already_recurring'))
		end
	end

	def is_recurring?
		self.status.to_sym == :recurring
	end

	def cancel(reason=:payment_failed)
		ends_at_date = reason == :recurring_payment_profile_cancel ? self.next_payment_due_at : Time.now
		self.update_attributes({
			status: :cancelled,
			cancellation_reason: reason,
			ends_at: ends_at_date,
			next_payment_due_at: nil
		})
		self.user.update_attribute(:status, :free)
	end

	def cancel_recurring_billing(site_name)
		if PaymentService.cancel_recurring_billing(self, site_name)
			if self.subscription_option.custom?
				new_status = :ending
			else
				new_status = self.starts_at > Time.now ? :cancelled : :ending
			end
			if self.update_attributes({status: new_status, ends_at: self.next_payment_due_at, next_payment_due_at: nil})
				update_mailchimp
				UserMailer.cancel_recurring_billing(self).deliver
				true
			else
				false
			end
		else
			false
		end
	end

	def within_one_day?
		self.created_at > (Time.now - 1.day)
	end

	def is_paypal?
		self.payment_system.to_sym == :paypal
	end

	def is_card?
		self.payment_system.to_sym == :chargebee
	end

	def update_mailchimp
		mailchimp_service = Maawol::Email::Mailchimp.new(self)
		mailchimp_service.update_on_list
	end

	def send_receipt
		UserMailer.subscription_receipt(self).deliver_now unless self.status == 'pending_paypal'
	end

	def send_admin_subscription_email
		if SiteSetting.site_admin_gets_new_subscription_email?
		  AdminMailer.new_subscription(self).deliver_now unless self.status == 'pending_paypal'
		end
	end
end