class AdminMailer < MaawolMailer
	include MandrillMailer

	def registration(user)
		@user = user
		subject = "New user registration"
		send_admin_mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
	end

	def payment_failed(subscription)
		@subscription = subscription
		subject = "Subscription cancelled due to failed payment"
		send_admin_mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
	end

	def new_subscription(subscription)
		@subscription = subscription
		subject = "New Subscription"
		send_admin_mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
	end

	def subscription_cancelled(subscription)
		@subscription = subscription
		subject = "Subscription has been cancelled"
		send_admin_mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
	end
end