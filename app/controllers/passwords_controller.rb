class PasswordsController < Clearance::PasswordsController

	def create
	  if user = find_user_for_create
	    user.forgot_password!
	    deliver_email(user)
	  end

	  flash[:notice] = t("passwords.create.description")
	  redirect_to sign_in_path
	end

	private

	def url_after_update
		lessons_path
	end
end