class SettingsController < MaawolController
	before_action :require_login

	def index
		@mode = 'account'
	end

	def update
		@mode = 'account'
		old_email = current_user.email
		old_digest_setting = current_user.receives_weekly_digest
		if current_user.update_attributes(user_params)
			if old_email != user_params[:email]
				mailchimp_service.update_on_list(old_email)
			elsif old_digest_setting != current_user.receives_weekly_digest
				mailchimp_service.update_on_list
			end
			redirect_to settings_path, notice: t('controllers.settings.update.success')
		else
			flash[:alert] = "#{t('controllers.settings.update.errors.prefix')}: #{legible_form_errors(current_user.errors)}"
			render :index
		end
	end

	def update_password
		@mode = 'password'
		if (user_params[:existing_password].length == 0) || (user_params[:password].length == 0) || (user_params[:password_confirm].length == 0)
				flash[:alert] = t('controllers.settings.update_password.errors.blank')
				params[:preclick] = 'password'
				render :index
		else
			if !User.authenticate(current_user.email, user_params[:existing_password])
				flash[:alert] = t('controllers.settings.update_password.errors.original_wrong')
				params[:preclick] = 'password'
				render :index
			elsif user_params[:password] != user_params[:password_confirm]
				flash[:alert] = t('controllers.settings.update_password.errors.match')
				params[:preclick] = 'password'
				render :index
			else
				if current_user.update_password(user_params[:password])
					redirect_to settings_path, notice: t('controllers.settings.update_password.success')
				else
					flash[:alert] = legible_form_errors(current_user.errors)
					params[:preclick] = 'password'
					render :index
				end
			end
		end
	end

private

	def mailchimp_service
		@mailchimp_service ||= Maawol::Email::Mailchimp.new(current_user)
	end

	def user_params
		params.require(:user).permit!
	end
end