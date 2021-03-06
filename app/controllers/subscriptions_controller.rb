class SubscriptionsController < MaawolController
	before_action :require_login

	def new
		if current_user.has_recurring_subscription?
			redirect_to settings_path(preclick: :membership), alert: t('controllers.subscriptions.new.errors.already_recurring')
		else
			flash[:notice] = t('controllers.subscriptions.new.from_locked') if params[:from] && params[:from] == "locked_lesson"
		end
	end

	def create
		subscription_level = params[:users_subscription][:level]
		session_discount_code = session[:discount_code] || nil
		payment = params[:payment]

		if payment[:type] == 'paypal'	# PAYPAL PAYMENT
			options = {
				site_name: school_setting("site-name"),
				current_user: current_user,
				subscription_level: subscription_level,
				session_discount_code: session_discount_code || nil,
				return_url: "#{host}/paypal/success",
				cancel_url: "#{host}/paypal/cancel",
				currency_code: Maawol::Config.currency_code
			}
			remote_subscription = Payment::Paypal::Subscription.new(options).create
			respond_to do |format|
				if remote_subscription.error
					format.json { @status = :error; @error = "#{remote_subscription.error}"; }
				else
					redirect_url = remote_subscription.links.find{|v| v.method == "REDIRECT" }.href
					format.json { @status = :success; @paypal_redirect = redirect_url; }
				end
			end
		else	# CARD PAYMENT
	    if error_msg = Payment::Chargebee::Service.detect_card_errors(payment)
	    	respond_to do |format|
	    		format.html do
	    			flash[:error] = error_msg
	    			redirect_to settings_path
	    		end
	    		format.json { @status = :error; @error = "#{error_msg}"; }
	    	end
		  else
				begin
					options = {
						current_user: current_user,
						subscription_level: subscription_level,
						card_details: payment,
						session_discount_code: session_discount_code || nil
					}
					@subscription = Payment::Chargebee::Subscription.new(options).create
					if !@subscription.errors.any?
						session.delete(:discount_code)
						@subscription.send_to_store_front
						respond_to do |format|
							format.html do
								flash[:notice] = t('views.subscription.success')
								redirect_to "/lessons?paid=1"
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
						format.json do
							@status = :error
							@error = error_msg
							@full_error = e.message
							@backtrace = e.backtrace
						end
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
					site_name = school_setting("site-name")
					if @subscription.cancel_recurring_billing(site_name)
						current_user.update_attribute(:status, :expiring)
						@status = :success
						@message = "#{t('views.subscription.recurring_cancelled')} #{@subscription.ends_at.strftime("%d %B, %Y")}"
						if SiteSetting.site_admin_gets_subscription_cancelled_email?
							AdminMailer.subscription_cancelled(@subscription).deliver_now
						end
					else
						@status = :error
						@message = t('views.subscription.errors.cancel_recurring')
					end
				end
			end
		end
	end
end