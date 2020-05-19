class Course < ApplicationRecord
  include Maawol::Models::Concerns::Productable
  include Maawol::Models::Concerns::TmpUploadable

	has_and_belongs_to_many :skill_levels
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories

  belongs_to :author
	has_many :teachings, :dependent => :destroy
	has_many :lessons, through: :teachings

	accepts_nested_attributes_for :teachings, :allow_destroy => true
	accepts_nested_attributes_for :lessons

  mount_uploader :image, CourseImageUploader

  after_save  :migrate_file_from_tmp_upload, if: -> { self.image_tmp_media_id.present? }

  def fields_for_upload
    [:image]
  end

  def snippet(count=250)
  	self.description.truncate(count).html_safe
  end

  def find_teaching_by_sort(sort)
  	self.teachings.find_by(sort: sort)
  end

  def self.published
  	where('publish_date <= ?', Time.now)
  end

  def is_published
    self.publish_date.present?
  end

  def lesson_index(lesson)
    self.teachings.find_by(lesson: lesson).sort
  end

  def id_for_admin_selector
    "course_#{self.id}"
  end

  def name_for_admin_selector
    "Course: #{self.name}"
  end

  def name_with_type
    "#{self.name} course"
  end

  def has_image?
    self.image.present?
  end
end