class ChargebeeWebhooksController < MaawolController

	def payment_messages
		@payment_messages ||= {
			success: 'success',
			not_recurring: "fail: user subscription is no longer recurring",
			not_found: "fail: user subscription ID #{@subscription_id} not found"
		}
	end

	def router
		action = params[:event_type].to_sym
		@notification_id = params[:id]
		@customer_id = params[:content][:customer][:id] if params[:content][:customer]
		@subscription_id = params[:content][:subscription][:id] if params[:content][:subscription]
		case action
		when :payment_succeeded
			handle_successful_payment
		when :payment_failed
			handle_failed_payment
		when :card_expiry_reminder
			handle_card_expiry_reminder
		else
			render json: { result: nil }
		end
	end

	def log_payment(outcome=:success)
		if @user_subscription = UsersSubscription.find_by(remote_customer_id: @customer_id, remote_subscription_id: @subscription_id)
			user_id = @user_subscription.user_id
			if @user_subscription.status.to_sym == :recurring
				amount = params[:content][:transaction][:amount].to_f / 100
				paid_at = Time.at(params[:content][:transaction][:date]).to_datetime
				is_first_payment = params[:content][:invoice][:first_invoice]
				payment = UsersSubscriptionPayment.create({
					users_subscription_id: @user_subscription.id,
					notification_id: @notification_id,
					amount: amount,
					status: outcome == :success ? :paid : :failed,
					paid_at: paid_at,
					first_payment: is_first_payment,
					created_at: Time.now
				})
				@user_subscription.increment!(:successful_recurring_payments)
				result = :success
			else
				result = :not_recurring
				DevMailer.notify_subscription_out_of_sync(@user_subscription, "payment_#{outcome}").deliver_now
			end
		else
			user_id = nil
			result = :not_found
		end
		ApiLog.webhook({
			service: :chargebee,
			user_id: user_id,
			request_method: "payment_#{outcome}",
			request_data: params.to_json,
			response: { status: result }
	  })
	  result
	end

	def handle_successful_payment
		result = log_payment(:success)
		amount = params[:content][:transaction][:amount].to_f / 100
		is_first_payment = params[:content][:invoice][:first_invoice]
		send_email = true
		if result == :success
			send_email = false if is_first_payment && @user_subscription.is_immediate
			UserMailer.payment_received(@user_subscription.user, amount).deliver_now if send_email
		end
		render json: { result: payment_messages[result] }
	end

	def handle_failed_payment
		result = log_payment(:fail)
		if result == :success
			@user_subscription.cancel(:payment_failed)
			UserMailer.payment_failed(@user_subscription.user).deliver_now
			if SiteSetting.site_admin_gets_failed_payment_email?
				AdminMailer.payment_failed(@user_subscription).deliver_now
			end
		end
		render json: { result: payment_messages[result] }
	end

	def handle_card_expiry_reminder
		if user_subscription = UsersSubscription.find_by(remote_customer_id: @customer_id, status: :recurring)
			UserMailer.card_expiry_reminder(user_subscription.user, params[:content][:card][:expiry_month], params[:content][:card][:expiry_year]).deliver_now
			user_id = user_subscription.user_id
			result = "reminder email sent"
		else
			user_id = nil
			result = "fail: recurring user subscription for customer ID #{@customer_id} not found"
		end
		ApiLog.webhook({
			service: :chargebee,
			user_id: user_id,
			request_method: :card_expiry_reminder,
			request_data: params.to_json,
			response: { status: result }
	  })
		render json: { result: result }
	end
end