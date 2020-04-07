class UploadVideoToVimeoJob < ApplicationJob
  queue_as :vimeo

  def perform(video)
  	video.upload_to_vimeo
  end
end