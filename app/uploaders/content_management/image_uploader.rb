module ContentManagement
  class ImageUploader < BaseUploader
    include CarrierWave::MiniMagick

    storage :fog

    version :large do
      process resize_to_fit: [700, 700]

      def store_dir
        "#{Rails.env}/#{site_basket_dir}/content-management/images/#{model.id}"
      end
    end

    version :medium do
      process resize_to_fit: [400, 400]

      def store_dir
        "#{Rails.env}/#{site_basket_dir}/content-management/images/#{model.id}"
      end
    end

    version :small do
      process resize_to_fit: [200, 200]

      def store_dir
        "#{Rails.env}/#{site_basket_dir}/content-management/images/#{model.id}"
      end
    end
  end
end