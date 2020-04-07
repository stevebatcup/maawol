class DownloadablesController < MaawolController
	def show
		@downloadable = nil
		@downloadable = Downloadable.find_by(token: params[:token]) if user_signed_in?
		if @downloadable.nil?
			if permission = ProductPermission.find_by(token: params[:token])
				if permission.expires_at > Time.now
					@downloadable = permission.product.productable
					permission.increment!(:download_count)
				end
			end
		end

		if @downloadable.present?
			 file_data = open(@downloadable.file.url) { |f| f.read }
			 filename_for_dl = "#{@downloadable.name.downcase.parameterize}.pdf"
			 send_data file_data, filename: filename_for_dl, type: @downloadable.file.content_type, disposition: 'attachment'
		else
			render_404
		end
	end
end