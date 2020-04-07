class StoreImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  storage :fog

  version :large do
    process resize_to_fit: [600, 400]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/#{folder_name}/#{model.id}"
    end
  end

  version :small do
    process resize_to_fit: [450, 250]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/#{folder_name}/#{model.id}"
    end
  end

  version :square do
    process resize_to_fit: [400, 400]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/#{folder_name}/#{model.id}"
    end
  end

  def folder_name
    "downloadable-stores"
  end
end