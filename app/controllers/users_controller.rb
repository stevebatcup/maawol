class UsersController < Clearance::UsersController
	def new
	  @user = User.new
    flash[:notice] = "Registered below for access to lessons" if params[:from] && params[:from] == "locked_lesson"
	  render template: "users/new"
	end

  def create
     @user = User.new(user_params)

     if recaptcha_verified(@user) && @user.save
       sign_in @user
       flash.discard
       redirect_back_or url_after_create
     else
       flash[:alert] = legible_form_errors(@user.errors)
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

end