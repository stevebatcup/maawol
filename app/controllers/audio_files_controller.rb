class AudioFilesController < MaawolController
	include Maawol::Controllers::DownloadController

	before_action	:set_resource, only: [:show]

	def show
		download_resource
	end

	private

	def filename_for_download
		"#{@resource.name.downcase.parameterize}.mp3"
	end

	def set_resource
		@resource = nil
		@resource = AudioFile.find_by(token: params[:token])
	end
end