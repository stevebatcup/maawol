class UserMailer < MaawolMailer
	include ActionView::Helpers::NumberHelper

	def welcome(user)
		vars = {
		  "FNAME" => user.first_name
		}
		subject = "Welcome to #{site_setting('Site name')}"
		body = mandrill_template('welcome-registration', merge_vars(vars))
		send_mail(user.email, subject, body, user.first_name, user.id)
	end

	def subscription_receipt(subscription)
		vars = {
		  "FNAME" => subscription.user.first_name,
		  "INITIAL_PRICE" => number_to_currency(subscription.initial_price),
		  "NEXT_PAYMENT_DUE" => subscription.next_payment_due_at.strftime("%A %B %d, %Y"),
		  "NEXT_PAYMENT_AMOUNT" => number_to_currency(subscription.initial_price),
		  "LOGIN_LINK" => new_user_session_url
		}
		subject = "Thanks for subscribing to #{site_setting('Site name')}"
		body = mandrill_template('welcome-subscription', merge_vars(vars))
		send_mail(subscription.user.email, subject, body, subscription.user.first_name, subscription.user.id)
	end

	def cancel_recurring_billing(subscription)
		vars = {
		  "FNAME" => subscription.user.first_name,
		  "SUBSCRIPTION_ENDS" => subscription.ends_at.strftime("%A %B %d, %Y")
		}
		subject = "Your subscription to #{site_setting('Site name')} has been cancelled"
		body = mandrill_template('subscription-canceled', merge_vars(vars))
		send_mail(subscription.user.email, subject, body, subscription.user.first_name, subscription.user.id)
	end

	def payment_failed(user)
	  subject = "Your card payment has failed"
	  vars = {
	    "FNAME" => user.display_name,
	  }
	  body = mandrill_template('payment-failed', merge_vars(vars))
	  send_mail(user.email, subject, body, user.first_name, user.id)
	end

	def payment_received(user, amount)
	  subject = "Renewal of your #{site_setting("Site easy name")} subscription"
	  vars = {
	    "FNAME" => user.display_name,
	    "AMOUNT" => number_to_currency(amount)
	  }
	  body = mandrill_template('payment-confirmation', merge_vars(vars))
	  send_mail(user.email, subject, body, user.first_name, user.id)
	end

	def card_expiry_reminder(user, month, year)
	  subject = "Update your payment details"
	  vars = {
	    "FNAME" => user.display_name,
	    "EXPIRY" => "#{Date::MONTHNAMES[month]} #{year}"
	  }
	  body = mandrill_template('card-expiry-reminder', merge_vars(vars))
	  send_mail(subscription.user.email, subject, body, subscription.user.first_name, subscription.user.id)
	end
end