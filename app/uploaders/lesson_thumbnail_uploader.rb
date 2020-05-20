class LessonThumbnailUploader < BaseUploader
  include CarrierWave::MiniMagick

  storage :fog

  def extension_whitelist
    image_extension_whitelist
  end

  def default_url(*args)
    Lesson.default_thumbnail_asset_path
  end

  version :large do
    process resize_to_fill: [600, 400]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/lesson-thumbnails/#{model.id}"
    end
  end

  version :small do
    process resize_to_fill: [450, 250]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/lesson-thumbnails/#{model.id}"
    end
  end

  version :square do
    process resize_to_fill: [400, 400]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/lesson-thumbnails/#{model.id}"
    end
  end
end
