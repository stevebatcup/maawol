class SettingsController < MaawolController
	before_action :require_login

	def index
	end

	def update
		old_email = current_user.email
		old_digest_setting = current_user.receives_weekly_digest
		if current_user.update_attributes(user_params)
			if old_email != user_params[:email]
				mailchimp_service.update_on_list(old_email)
			elsif old_digest_setting != current_user.receives_weekly_digest
				mailchimp_service.update_on_list
			end
			redirect_to settings_path, notice: "Settings updated"
		else
			flash.alert = "Sorry, there was an error updating your account settings: #{legible_form_errors(current_user.errors)}"
			render :index
		end
	end

	def update_password
		if (user_params[:existing_password].length == 0) || (user_params[:password].length == 0) || (user_params[:password_confirm].length == 0)
				flash.alert = "To change your password please fill out all 3 fields"
				render :index
		else
			if current_user.valid_password?(user_params[:existing_password])
				if user_params[:password] != user_params[:password_confirm]
					flash.alert = "Please make sure your new password matches the confirmation"
					render :index
				elsif user_params[:password].length < 8
					flash.alert = "Please make sure your new password is at least 8 characters long"
					render :index
				else
					current_user.update_attribute(:password, user_params[:password])
					bypass_sign_in(current_user)
					redirect_to settings_path, notice: "Your password has been updated"
				end
			else
				flash.alert = "The existing password you entered is wrong, please try again"
				render :index
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