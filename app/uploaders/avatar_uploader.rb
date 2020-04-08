class AvatarUploader < BaseUploader

  include CarrierWave::MiniMagick

  storage :fog

  def default_url(*args)
    ActionController::Base.helpers.asset_path "no-avatar.png"
  end

  version :thumbnail do
    process resize_to_fit: [90, 105]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/avatars/#{model.id}"
    end
  end

  version :small do
    process resize_to_fit: [80, 90]

    def store_dir
      "#{Rails.env}/#{site_basket_dir}/avatars/#{model.id}"
    end
  end
end