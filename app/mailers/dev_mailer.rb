class DevMailer < MaawolMailer
	def notify_subscription_out_of_sync(subscription, action)
		merge_vars = {
			SUBSCRIPTION_ID: subscription.id
		}
		subject = "Subscription found out of sync (on #{action} notification)"
		body = template('subscription-out-of-sync', merge_vars)
		send_dev_mail(subject, body)
	end

	def notify_error_paypal_agreement(agreement)
		merge_vars = {
			AGREEMENT_DATA: @agreement.inspect
		}
		subject = "Paypal agreement error"
		body = template('paypal-agreement-error', merge_vars)
		send_dev_mail(subject, body)
	end

	def notify_error_paypal_flow(user, token, e)
		merge_vars = {
			USER_ID: user.id,
			PAYPAL_TOKEN: token,
			ERROR_MSG: e.message
		}
		subject = "Paypal incomplete session"
		body = template('paypal-flow-error', merge_vars)
		send_dev_mail(subject, body)
	end

	private

	def send_dev_mail(subject, body)
	  data = mail_data(Maawol::Config.mail_interceptor_to, subject, body)
	  response = api.messages.send(data)
	  log_request(nil, "send_dev_mail", data, response)
	end
end