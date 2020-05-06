class TmpMediaUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :file

  def extension_whitelist
  	model.file_extension_whitelist
  end

  def store_dir
  	if Rails.env.development?
			"uploads/tmp/media/#{model.id}"
		else
			"/usr/share/nginx/html/#{Maawol::Config.site_slug}/uploads/tmp/media#{model.id}"
		end
	end
end