module Admin
  class AuthorsController < Admin::ApplicationController
		def set_main
			if author = Author.find_by(id: params[:id])
				Author.update_all(is_main: false)
				if author.update_attribute(:is_main, true)
					render json: { status: :success }
				else
					render json: { status: :error, message: legible_form_errors(author.errors) }
				end
			else
				render json: { status: :error, message: "Cannot find an author with ID #{params[:id]}" }
			end
		end
	end
end