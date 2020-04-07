class SubscriptionsController < MaawolController
	before_action :require_login

	def new
		if current_user.has_recurring_subscription?
			flash[:error] = I18n.t('views.subscription.errors.already_recurring')
			redirect_to settings_path(preclick: :cancel_recurring)
		end
	end

	def create
		subscription_level = params[:users_subscription][:level]
		session_discount_code = session[:discount_code] || nil
		payment = params[:payment]

		if payment[:type] == 'paypal'	# PAYPAL PAYMENT
			remote_subscription = PaymentService::Paypal.setup_recurring_billing({
				site_name: site_setting("Site name"),
				current_user: current_user,
				subscription_level: subscription_level,
				session_discount_code: session_discount_code || nil,
				return_url: "#{host}/paypal/success",
				cancel_url: "#{host}/paypal/cancel"
			})
			respond_to do |format|
				if remote_subscription.error
					format.json { @status = :error; @error = "#{remote_subscription.error}"; }
				else
					redirect_url = remote_subscription.links.find{|v| v.method == "REDIRECT" }.href
					format.json { @status = :success; @paypal_redirect = redirect_url; }
				end
			end
		else	# CARD PAYMENT
	    if error_msg = PaymentService::Chargebee.detect_card_errors(payment)
	    	respond_to do |format|
	    		format.html do
	    			flash[:error] = error_msg
	    			redirect_to settings_path
	    		end
	    		format.json { @status = :error; @error = "#{error_msg}"; }
	    	end
		  else
				begin
					@subscription = PaymentService::Chargebee.do_subscription_payment({
						current_user: current_user,
						subscription_level: subscription_level,
						card_details: payment,
						session_discount_code: session_discount_code || nil
					})
					unless @subscription.changed?
						session.delete(:discount_code)
						respond_to do |format|
							format.html do
								flash[:notice] = t('views.subscription.success')
								redirect_to settings_path
							end
							format.json { @status = :success }
						end
					else
						respond_to do |format|
							@error = legible_form_errors(@subscription.errors)
							format.html do
								flash[:error] = @error
								redirect_to settings_path
							end
							format.json { @status = :error }
						end
					end
				rescue Exception => e
					error_msg = t('views.subscription.errors.card_fail')
					respond_to do |format|
						format.html do
							flash[:error] = error_msg
							redirect_to settings_path
						end
						format.json { @status = :error; @error = error_msg; @full_error = e.message }
					end
				end
			end
		end
	end

	def show
		respond_to do |format|
			format.json do
				@subscription = UsersSubscription.find_by_id(params[:id])
				if @subscription.nil? || (@subscription.user_id != current_user.id)
					@status = :error
					@message = t('views.account.subscription.error.auth')
				else
					@status = :success
				end
			end
		end
	end

	def update # cancel recurring billing
		respond_to do |format|
			@subscription = UsersSubscription.find_by_id(params[:id])
			format.json do
				if @subscription.nil? || (@subscription.user_id != current_user.id)
					@status = :error
					@message = t('views.account.subscription.cancellation.error.auth')
				else
					site_name = site_setting("Site name")
					if @subscription.cancel_recurring_billing(site_name)
						current_user.update_attribute(:status, :expiring)
						@status = :success
						@message = "#{t('views.subscription.recurring_cancelled')} #{@subscription.ends_at.strftime("%d %B, %Y")}"
						AdminMailer.subscription_cancelled(@subscription).deliver_now
					else
						@status = :error
						@message = t('views.subscription.errors.cancel_recurring')
					end
				end
			end
		end
	end
end