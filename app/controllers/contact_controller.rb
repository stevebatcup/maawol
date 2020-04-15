class ContactController < MaawolController
	def new
		@contact = Contact.new
		if user_signed_in?
			@contact.email = current_user.email
			@contact.name = current_user.full_name
		end

		if @stuck = params[:stuck].present?
			@contact.subject = "Help! I don't know what to work on!"
			@questions = StuckQuestion.includes(:stuck_answers).references(:stuck_answers).order(sort: :asc)
		end
	end

	def create
		@contact = Contact.new({
			name: contact_params[:name],
			email: contact_params[:email],
			subject: contact_params[:subject]
		})
		@contact.user_id = current_user.id if user_signed_in?
		if contact_params[:message].present?
			@contact[:message] = contact_params[:message]
		else
			@contact.gather_question_data(contact_params)
		end
		if !user_signed_in? && Rails.env.production? && !verify_recaptcha(model: @contact, secret_key: Rails.application.credentials.recaptcha[:secret_key])
			flash[:alert] = @contact.errors.full_messages[0]
			render :new
		else
			if @contact.save
				if contact_params[:message].present?
					notice = "Thanks I'll get back in touch ASAP"
					if contact_params[:from_home].present?
						redirect_to root_path, notice: notice
					else
						redirect_to new_contact_path, notice: notice
					end
				else
					redirect_to lessons_path(stuck: true), notice: "Thanks! I'll get back to you ASAP with some suggestions of things to work on."
				end
			else
				flash[:alert] = "Sorry there was an error sending your message: #{legible_form_errors(@contact.errors)}"
				render :new
			end
		end
	end

private

	def contact_params
		params.require(:contact).permit!
	end

end