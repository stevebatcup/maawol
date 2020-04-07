class AlbumCoverUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :fog

  version :large do
    process resize_to_fit: [500, 500]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/album-covers/#{model.id}"
    end
  end

  version :small do
    process resize_to_fit: [250, 250]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/album-covers/#{model.id}"
    end
  end

  def store_dir
    "#{Rails.env}/#{site_basket_dir}/album-covers/#{model.id}"
  end
end