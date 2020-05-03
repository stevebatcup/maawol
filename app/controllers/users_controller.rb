class UsersController < Clearance::UsersController
	def new
	  @user = User.new
	  render template: "users/new"
	end

  def create
  	@user = User.new(user_params)

    if recaptcha_ok(@user) && @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  private

  def url_after_create
  	lessons_path
  end

  def user_params
    params[:user].permit(:first_name, :last_name, :email, :password)
  end

  def recaptcha_ok(user)
    recaptcha_ok = true
    if !Rails.env.production?
      recaptcha_ok = verify_recaptcha(model: user, secret_key: Rails.application.credentials.recaptcha_secret_key)
    end
  end
end