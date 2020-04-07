module Maawol
	class AdminMailer < ApplicationMailer
		include ApplicationControllerConcern

		default(
		  from: Rails.application.credentials.mail[:from],
		  reply_to: Rails.application.credentials.mail[:reply_to]
		)

		def registration(user)
			@user = user
			subject = "New user registration"
			mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
		end

		def payment_failed(subscription)
			@subscription = subscription
			subject = "Subscription cancelled due to failed payment"
			mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
		end

		def new_subscription(subscription)
			@subscription = subscription
			subject = "New Subscription"
			mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
		end

		def subscription_cancelled(subscription)
			@subscription = subscription
			subject = "Subscription has been cancelled"
			mail({to: Rails.application.credentials.mail[:admin_to], subject: subject })
		end
	end
end