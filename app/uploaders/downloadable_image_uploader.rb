class DownloadableImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  storage :fog

  version :large do
    process resize_to_fill: [600, 400]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/downloadables/#{model.id}/image"
    end
  end

  version :small do
    process resize_to_fill: [450, 250]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/downloadables/#{model.id}/image"
    end
  end

  def folder_name
    "downloadables"
  end
end