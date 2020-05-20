class ContactController < MaawolController
	def new
		@contact = Contact.new
		@contact.subject = t('controllers.contact.new.subject.default')

		if signed_in?
			if params[:lesson_request].present?
				require_subscription
				@contact.subject = t('controllers.contact.new.subject.lesson_request')
				@lesson_request = true
			elsif params[:stuck].present?
				setup_stuck_form
			end
		end
	end

	def create
		@contact = Contact.new({
			name: contact_params[:name],
			email: contact_params[:email],
			subject: contact_params[:subject]
		})
		@contact.user_id = current_user.id if signed_in?
		if is_stuck_submission?
			@contact.gather_question_data(contact_params)
		else
			@contact[:message] = contact_params[:message]
		end

		if recaptcha_verified(@contact) && @contact.save
			if contact_params[:message].present?
				notice = t('controllers.contact.create.success.default')
				if contact_params[:from_home].present?
					redirect_to root_path, notice: notice
				else
					redirect_to new_contact_path, notice: notice
				end
			else
				redirect_to lessons_path(stuck: true), notice: t('controllers.contact.create.success.stuck')
			end
		else
			flash[:alert] = "#{t('controllers.contact.create.error_prefix')}: #{legible_form_errors(@contact.errors)}"
			setup_stuck_form if is_stuck_submission?
			render :new
		end
	end

private

	def setup_stuck_form
		@stuck = true
		@contact.subject = t('controllers.contact.new.subject.stuck')
		@questions = StuckQuestion.includes(:stuck_answers).references(:stuck_answers).order(sort: :asc)
	end

	def is_stuck_submission?
		!contact_params[:message].present?
	end

	def contact_params
		params.require(:contact).permit!
	end

end