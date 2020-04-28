class AudioFileUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :fog

  def extension_whitelist
    %w(mp3 wav ogg)
  end

  def store_dir
    "#{Rails.env}/#{site_basket_dir}/audio/#{model.id}"
  end
end