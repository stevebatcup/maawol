class Downloadable < ApplicationRecord
  include Maawol::Models::Concerns::Productable
  include Maawol::Models::Concerns::TmpUploadable

  mount_uploader :file, DownloadableFileUploader
  mount_uploader :image, DownloadableImageUploader
  belongs_to  :author

  before_save :set_token
  after_save  :migrate_file_from_tmp_upload, if: -> { self.file_tmp_media_id.present? || self.image_tmp_media_id.present? }

  def fields_for_upload
    [:file, :image]
  end

  def full_path
  	self.token.present? ? Rails.application.routes.url_helpers.download_file_path(token: self.token) : self.file.url
  end

  def full_url
    self.token.present? ? Rails.application.routes.url_helpers.download_file_url(token: self.token) : self.file.url
  end

  def basket_url
    self.token.present? ? Rails.application.routes.url_helpers.file_basket_url(token: self.token) : ''
  end

  def id_for_admin_selector
    "downloadable_#{self.id}"
  end

  def name_for_admin_selector
    "Score: #{self.name}"
  end

  def name_with_type
    "#{self.name} score"
  end

  def has_image?
    self.image.present?
  end
end