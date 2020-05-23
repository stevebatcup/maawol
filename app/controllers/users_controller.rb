class UsersController < Clearance::UsersController
	def new
	  @user = User.new
    flash.now[:notice] = t("controllers.users.new.from_locked") if params[:from] && params[:from] == "locked_lesson"
	  render template: "users/new"
	end

  def create
     @user = User.new(user_params)

     if recaptcha_verified(@user) && @user.save
       sign_in @user
       flash.discard
       respond_to do |format|
        format.html { redirect_back_or url_after_create }
        format.json do
          render json: { status: :success, redirect: url_after_create }
        end
      end
     else
        respond_to do |format|
          format.html do
            flash[:alert] = legible_form_errors(@user.errors)
            render template: "users/new"
          end
          format.json do
            render json: {
              status: :error,
              message: legible_form_errors(@user.errors),
              field: main_error_field(@user.errors)
            }
          end
        end
     end
  end

  def destroy
    DeleteUserJob.perform_later(current_user)
    sign_out
    flash[:alert] = t('views.account_settings.details.delete.account_deleted_html',
                        main_tutor: Author.main_author.name,
                        school: SiteSetting.school_name).html_safe
    render json: { status: :success }
  end

  private

  def url_after_create
  	lessons_path
  end

  def user_params
    params[:user].permit(:first_name, :last_name, :email, :password)
  end

end