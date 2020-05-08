class DownloadableImageUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :fog

  def extension_whitelist
    image_extension_whitelist
  end

  version :large do
    process resize_to_fit: [600, 400]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/downloadables/images/#{model.id}"
    end
  end

  version :small do
    process resize_to_fit: [450, 250]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/downloadables/images/#{model.id}"
    end
  end
end