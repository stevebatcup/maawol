class AdminMailer < MaawolMailer
	include Maawol::Email::Mandrill

	def registration(user)
		merge_vars = {
			USER_NAME: user.full_name,
			USER_EMAIL: user.email
		}
		body = template('new-registration', merge_vars)
		send_admin_mail("New user registration", body)
	end

	def payment_failed(subscription)
		merge_vars = {
			USER_NAME: subscription.user.full_name,
			PAYMENT_METHOD: subscription.payment_system,
			REMOTE_SUBSCRIPTION_ID: subscription.remote_subscription_id,
			REMOTE_CUSTOMER_ID: subscription.remote_customer_id
		}
		body = template('failed-subscription-payment-admin', merge_vars)
		send_admin_mail("Subscription cancelled due to a failed payment", body)
	end

	def new_subscription(subscription)
		merge_vars = {
			USER_NAME: subscription.user.full_name,
			PAYMENT_METHOD: subscription.payment_system,
			REMOTE_SUBSCRIPTION_ID: subscription.remote_subscription_id,
			REMOTE_CUSTOMER_ID: subscription.remote_customer_id
		}
		body = template('new-subscription', merge_vars)
		send_admin_mail("New Subscription", body)
	end

	def subscription_cancelled(subscription)
		merge_vars = {
			USER_NAME: subscription.user.full_name,
			PAYMENT_METHOD: subscription.payment_system,
			REMOTE_SUBSCRIPTION_ID: subscription.remote_subscription_id,
			REMOTE_CUSTOMER_ID: subscription.remote_customer_id
		}
		body = template('subscription-cancelled', merge_vars)
		send_admin_mail("Subscription has been cancelled", body)
	end
end