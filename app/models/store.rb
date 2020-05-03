class Store < ApplicationRecord
  has_many :products, :dependent => :destroy
  has_many :downloadables, through: :products, source: :productable, source_type: 'Downloadable'
  has_many :courses, through: :products, source: :productable, source_type: 'Course'
  has_many :audio_files, through: :products, source: :productable, source_type: 'AudioFile'

  accepts_nested_attributes_for :products, :allow_destroy => true
  accepts_nested_attributes_for :downloadables

  mount_uploader :image, StoreImageUploader
  before_save	:slugify_name

  def slugify_name
  	self.slug = name.parameterize
  end

  def full_path
  	Rails.application.routes.url_helpers.store_path(slug: self.slug)
  end

  def full_url
  	Rails.application.routes.url_helpers.store_url(slug: self.slug)
  end
end