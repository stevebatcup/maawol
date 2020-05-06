class VideoUploader < BaseUploader

  storage :file

  def extension_whitelist
    %w(mp4 mov wmv avi flv)
  end

  def store_dir
  	if Rails.env.development?
			"uploads/tmp/videos/#{model.id}"
		else
			"/usr/share/nginx/html/#{Maawol::Config.site_slug}/uploads/tmp/videos/#{model.id}"
		end
  end
end