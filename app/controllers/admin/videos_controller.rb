module Admin
	class VideosController < Admin::ApplicationController
		def set_for_homepage
			if video = Video.find_by(id: params[:id])
				Video.update_all(is_for_homepage: false)
				if video.update_attribute(:is_for_homepage, true)
					render json: { status: :success }
				else
					render json: { status: :error, message: legible_form_errors(video.errors) }
				end
			else
				render json: { status: :error, message: "Cannot find a video with ID #{params[:id]}" }
			end
		end
	end
end