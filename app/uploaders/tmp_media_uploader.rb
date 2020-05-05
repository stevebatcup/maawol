class TmpMediaUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :file

  def extension_whitelist
  	model.file_extension_whitelist
  end

  def store_dir
		"uploads/tmp/media/#{model.id}"
	end
end