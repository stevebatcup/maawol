class ContactController < MaawolController
	def new
		@contact = Contact.new
		@contact.subject = "Get in touch"

		if signed_in?
			if params[:lesson_request].present?
				require_subscription
				@contact.subject = "Request a lesson"
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
				notice = "Thanks We'll be back in touch ASAP"
				if contact_params[:from_home].present?
					redirect_to root_path, notice: notice
				else
					redirect_to new_contact_path, notice: notice
				end
			else
				redirect_to lessons_path(stuck: true), notice: "Thanks! We'll get back to you ASAP with some suggestions of things to work on."
			end
		else
			flash[:alert] = "Sorry there was an error sending your message: #{legible_form_errors(@contact.errors)}"
			setup_stuck_form if is_stuck_submission?
			render :new
		end
	end

private

	def setup_stuck_form
		@stuck = true
		@contact.subject = "Help! I don't know what to work on!"
		@questions = StuckQuestion.includes(:stuck_answers).references(:stuck_answers).order(sort: :asc)
	end

	def is_stuck_submission?
		!contact_params[:message].present?
	end

	def contact_params
		params.require(:contact).permit!
	end

end