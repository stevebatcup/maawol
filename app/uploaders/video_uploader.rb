class VideoUploader < BaseUploader

  storage :file

  def store_dir
    Rails.root.join 'tmp/uploads/videos'
  end
end