class BaseUploader < CarrierWave::Uploader::Base
  def site_basket_dir
    model.class.connection_config[:database].gsub(/maawol_/, '')
  end
end