class AvatarUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :fog

  def extension_whitelist
    image_extension_whitelist
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path "no-avatar.png"
  end

  version :thumbnail do
    process resize_to_fill: [120, 120]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/avatars/#{model.id}"
    end
  end

  version :small do
    process resize_to_fill: [80, 80]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/avatars/#{model.id}"
    end
  end
end