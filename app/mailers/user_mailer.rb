class UserMailer < MaawolMailer
	include ActionView::Helpers::NumberHelper

	def welcome(user)
		merge_vars = {
		  "FNAME" => user.first_name
		}
		subject = "Welcome to #{school_setting('site-name')}"
		body = template('welcome', merge_vars)
		send_mail(user.email, subject, body, user.first_name, user.id)
	end

	def subscription_receipt(subscription)
		merge_vars = {
		  "FNAME" => subscription.user.first_name,
		  "INITIAL_PRICE" => number_to_currency(subscription.initial_price, unit: Maawol::Config.currency_symbol),
		  "NEXT_PAYMENT_DUE" => subscription.next_payment_due_at.strftime("%A %B %d, %Y"),
		  "NEXT_PAYMENT_AMOUNT" => number_to_currency(subscription.initial_price, unit: Maawol::Config.currency_symbol),
		  "LOGIN_LINK" => sign_in_url
		}
		subject = "Thanks for subscribing to #{school_setting('site-name')}"
		body = template('subscription-receipt', merge_vars)
		send_mail(subscription.user.email, subject, body, subscription.user.first_name, subscription.user.id)
	end

	def cancel_recurring_billing(subscription)
		merge_vars = {
		  "FNAME" => subscription.user.first_name,
		  "SUBSCRIPTION_ENDS" => subscription.ends_at.strftime("%A %B %d, %Y")
		}
		subject = "Your subscription to #{school_setting('site-name')} has been cancelled"
		body = template('subscription-cancellation', merge_vars)
		send_mail(subscription.user.email, subject, body, subscription.user.first_name, subscription.user.id)
	end

	def payment_failed(user)
	  subject = "Your card payment has failed"
	  merge_vars = {
	    "FNAME" => user.display_name,
	  }
	  body = template('failed-subscription-payment', merge_vars)
	  send_mail(user.email, subject, body, user.first_name, user.id)
	end

	def payment_received(user, amount)
	  subject = "Renewal of your #{school_setting("site-easy-name")} subscription"
	  merge_vars = {
	    "FNAME" => user.display_name,
	    "AMOUNT" => number_to_currency(amount, unit: Maawol::Config.currency_symbol)
	  }
	  body = template('subscription-payment-received', merge_vars)
	  send_mail(user.email, subject, body, user.first_name, user.id)
	end

	def card_expiry_reminder(user)
	  subject = "Update your payment details"
	  merge_vars = {
	    "FNAME" => user.display_name
	  }
	  body = template('card-expiry-reminder', merge_vars)
	  send_mail(user.email, subject, body, user.first_name, user.id)
	end
end