class DownloadableFileUploader < BaseUploader
  storage :fog

  def extension_whitelist
    %w(pdf doc docx)
  end

  def store_dir
    "#{Rails.env}/#{site_basket_dir}/downloadables/#{model.id}"
  end

  def extension_whitelist
    %w(pdf doc docx)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.name.parameterize}.#{file.extension}" if original_filename.present?
  end
end