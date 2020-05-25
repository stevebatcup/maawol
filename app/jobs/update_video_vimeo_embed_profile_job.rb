class UpdateVideoVimeoEmbedProfileJob < ApplicationJob
  queue_as :vimeo

  def perform(video)
  	video.update_vimeo_embed_profile
  end
end