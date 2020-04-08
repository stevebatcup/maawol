class DevMailer < MaawolMailer
	def notify_subscription_out_of_sync_with_chargebee(subscription, action)
		@subscription = subscription
		@action = action.to_s
		subject = "Subscription found out of sync with Chargebee (on #{@action} notification)"
		mail({to: Rails.application.credentials.mail[:interceptor_to], subject: subject })
	end

	def notify_subscription_out_of_sync_with_paypal(subscription, action)
		@subscription = subscription
		@action = action.to_s
		subject = "Subscription found out of sync with Paypal (on #{@action} notification)"
		mail({to: Rails.application.credentials.mail[:interceptor_to], subject: subject })
	end

	def notify_error_paypal_agreement(agreement)
		@agreement = agreement
		subject = "Paypal agreement error"
		mail({to: Rails.application.credentials.mail[:interceptor_to], subject: subject })
	end

	def notify_error_paypal_flow(user, token, exc)
		@user = user
		@token = token
		@exc = exc
		subject = "Paypal incomplete session"
		mail({to: Rails.application.credentials.mail[:interceptor_to], subject: subject })
	end
end