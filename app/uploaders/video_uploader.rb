class VideoUploader < BaseUploader

  storage :file

  def extension_whitelist
    %w(mp4 mov wmv avi flv)
  end

  def store_dir
    Rails.root.join 'tmp/uploads/videos'
  end
end