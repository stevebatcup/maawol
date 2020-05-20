class SiteImageUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :fog

  def extension_whitelist
    image_extension_whitelist
  end

  version :large_square do
    process resize_to_fill: [500, 500]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/site-images/#{model.id}"
    end
  end

  version :small_square do
    process resize_to_fill: [170, 170]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/site-images/#{model.id}"
    end
  end

  version :large_landscape do
    process resize_to_fill: [600, 200]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/site-images/#{model.id}"
    end
  end

  version :small_landscape do
    process resize_to_fill: [200, 70]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/site-images/#{model.id}"
    end
  end

  version :tiny do
    process resize_to_fill: [16, 16]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/site-images/#{model.id}"
    end
  end

  def store_dir
    "#{Rails.env}/#{site_basket_dir}/site-images/#{model.id}"
  end
end