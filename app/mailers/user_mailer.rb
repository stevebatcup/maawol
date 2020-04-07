module Maawol
	class UserMailer < ApplicationMailer
		include ActionView::Helpers::NumberHelper
		include ApplicationControllerConcern

		def reset_password_instructions(user, token, options)
			merge_vars = {
			  "RESET_LINK" => edit_user_password_url(user, reset_password_token: token),
			  "FNAME" => user.first_name
			}
			subject = "Reset your password"
			body = mandrill_template('password-reset', merge_vars)
			send_mail(user, subject, body)
		end

		def welcome(user)
			merge_vars = {
			  "FNAME" => user.first_name
			}
			subject = "Welcome to #{site_setting('Site name')}"
			body = mandrill_template('welcome-registration', merge_vars)
			send_mail(user, subject, body)
		end

		def subscription_receipt(subscription)
			merge_vars = {
			  "FNAME" => subscription.user.first_name,
			  "INITIAL_PRICE" => number_to_currency(subscription.initial_price),
			  "NEXT_PAYMENT_DUE" => subscription.next_payment_due_at.strftime("%A %B %d, %Y"),
			  "NEXT_PAYMENT_AMOUNT" => number_to_currency(subscription.initial_price),
			  "LOGIN_LINK" => new_user_session_url
			}
			subject = "Thanks for subscribing to #{site_setting('Site name')}"
			body = mandrill_template('welcome-subscription', merge_vars)
			send_mail(subscription.user, subject, body)
		end

		def cancel_recurring_billing(subscription)
			merge_vars = {
			  "FNAME" => subscription.user.first_name,
			  "SUBSCRIPTION_ENDS" => subscription.ends_at.strftime("%A %B %d, %Y")
			}
			subject = "Your subscription to #{site_setting('Site name')} has been cancelled"
			body = mandrill_template('subscription-canceled', merge_vars)
			send_mail(subscription.user, subject, body)
		end

		def payment_failed(recipient)
		  subject = "Your card payment has failed"
		  merge_vars = {
		    "FNAME" => recipient.display_name,
		  }
		  body = mandrill_template('payment-failed', merge_vars)
		  send_mail(recipient, subject, body)
		end

		def payment_received(recipient, amount)
		  subject = "Renewal of your #{site_setting("Site easy name")} subscription"
		  merge_vars = {
		    "FNAME" => recipient.display_name,
		    "AMOUNT" => number_to_currency(amount)
		  }
		  body = mandrill_template('payment-confirmation', merge_vars)
		  send_mail(recipient, subject, body)
		end

		def card_expiry_reminder(recipient, month, year)
		  subject = "Update your payment details"
		  merge_vars = {
		    "FNAME" => recipient.display_name,
		    "EXPIRY" => "#{Date::MONTHNAMES[month]} #{year}"
		  }
		  body = mandrill_template('card-expiry-reminder', merge_vars)
		  send_mail(recipient, subject, body)
		end
	end
end