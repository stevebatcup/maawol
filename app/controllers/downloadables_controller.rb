class DownloadablesController < MaawolController
	include Maawol::Controllers::DownloadController

	before_action	:set_resource, only: [:show]

	def show
		download_resource
	end

	private

	def filename_for_download
		"#{@resource.name.downcase.parameterize}.pdf"
	end

	def set_resource
		@resource = nil
		@resource = Downloadable.find_by(token: params[:token])
	end
end