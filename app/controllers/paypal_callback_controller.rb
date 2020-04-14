class PaypalCallbackController < MaawolController
	layout	'home'
	skip_before_action :verify_authenticity_token

	def create
		begin
			PaymentService::Paypal.complete_agreement(current_user, params[:token], session)
			flash[:notice] = t('views.subscription.success')
			redirect_to settings_path
		rescue Exception => e
			DevMailer.notify_error_paypal_flow(current_user, params[:token], e).deliver_now
			flash[:alert] = "Ooops there has been an error completing your paypal agreement: #{e.message}"
			redirect_to subscribe_path
		end
	end

	def destroy
		redirect_to "/subscribe"
	end

	def webhooks_router
		action = (params['txn_type'] || 'none').to_sym
		@notification_id = params['ipn_track_id']
		@subscription_id = params['recurring_payment_id'] if params['recurring_payment_id']
		case action
		when :recurring_payment
			if ['completed', 'processed'].include?(params[:payment_status].to_s.downcase)
				handle_successful_payment
			else
				handle_failed_payment("recurring_payment_#{params[:payment_status].to_s.downcase}")
			end
		when :recurring_payment_outstanding_payment_failed, :recurring_payment_profile_cancel, :recurring_payment_failed, :recurring_payment_skipped
			handle_failed_payment(action)
		else
			render json: { result: nil }
		end
	end

private
	def payment_messages
		@payment_messages ||= {
			success: 'success',
			not_recurring: "fail: user subscription is no longer recurring",
			not_found: "fail: user subscription ID #{@subscription_id} not found"
		}
	end

	def log_payment(outcome=:success)
		if @user_subscription = UsersSubscription.find_by(remote_subscription_id: @subscription_id)
			user_id = @user_subscription.user_id
			if @user_subscription.status.to_sym == :recurring
				amount = params['amount'].to_f
				if outcome == :success
					paid_at = Time.parse(params['payment_date']).to_datetime
				else
					paid_at = Time.parse(params['time_created']).to_datetime
				end
				payment = UsersSubscriptionPayment.create({
					users_subscription_id: @user_subscription.id,
					notification_id: @notification_id,
					amount: amount,
					status: outcome == :success ? :paid : :failed,
					paid_at: paid_at,
					first_payment: false,
					created_at: Time.now
				})
				@user_subscription.increment!(:successful_recurring_payments) if outcome == :success
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
			service: :paypal,
			user_id: user_id,
			request_method: "payment_#{outcome}",
			request_data: params.to_json,
			response: { status: result }
	  })
	  result
	end

	def handle_successful_payment
		result = log_payment(:success)
		UserMailer.payment_received(@user_subscription.user, params[:amount].to_f).deliver_now if result == :success
		render json: { result: payment_messages[result] }
	end

	def handle_failed_payment(action=:payment_failed)
		result = log_payment(:fail)
		if result == :success
			@user_subscription.cancel(action)
			unless action == :recurring_payment_profile_cancel
				UserMailer.payment_failed(@user_subscription.user).deliver_now
				AdminMailer.payment_failed(@user_subscription).deliver_now
			end
		end
		render json: { result: payment_messages[result] }
	end
end