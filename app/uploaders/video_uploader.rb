class VideoUploader < BaseUploader

  storage :file

  def extension_whitelist
    %w(mp4 mov wmv avi flv)
  end

  def store_dir
    "uploads/tmp/videos/#{model.id}"
  end
end