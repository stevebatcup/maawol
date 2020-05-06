class TmpMediaController < ApplicationController
	skip_before_action :verify_authenticity_token

	def	create
		begin
			@media = TmpMedium.new(
				file_type: params[:file_type],
				resource_class: params[:resource_class],
				media_file: params[:file]
			)
			if @media.save!
				render json: { status: :success, media: { id: @media.id, url: @media.uploads_url } }
			else
				render json: { status: :error, error: 'Failed to process' }, status: 422
			end
		rescue Exception => e
			render json: { status: :error, error: e.message }, status: 422
		end
	end

	def destroy
		if @media = TmpMedium.find(params[:id])
			@media.destroy
			render json: { status: :success }
		else
			render json: { status: :error, message: legible_form_errors(@meda) }
		end
	end
end