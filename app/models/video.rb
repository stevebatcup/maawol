class Video < ApplicationRecord
  include Maawol::Models::Concerns::Vimeoable
  include Maawol::Models::Concerns::TmpUploadable

  has_and_belongs_to_many :lessons

  mount_uploader :tmp_video_file, VideoUploader

  validates_presence_of  :name
  validate  :tmp_video_file_type, on: [:create, :update], if: -> { tmp_video_file.file.present? }

  before_save :set_status
  after_save :perform_upload_to_vimeo_job, if: -> { self.tmp_video_file_tmp_media_id.present? }
  after_destroy :delete_from_vimeo

  enum  status: [:no_video, :pending, :uploaded]

  def field_for_upload
    :tmp_video_file
  end

  def self.valid_extension?(filename)
    ext = File.extname(filename)
    %w( .mp4 .mov .wmv .avi ).include? ext.downcase
  end

  def set_status
    if tmp_video_file.file.present?
      self.status = :pending
    elsif vimeo_data.present?
      self.status = :uploaded
    else
      self.status = :no_video
    end
  end

  def tmp_video_file_type
    if !self.class.valid_extension?(self.tmp_video_file.file.original_filename)
      errors[:tmp_video_file] << "Invalid file format, please use one of the following: .mp4 .mov .wmv or .avi"
    end
  end

  def human_status
    return '' if self.status.nil?
    case self.status.to_sym
    when :pending
      "Video is uploading to Vimeo, please wait....."
    when :uploaded
      "Your video has been uploaded to Vimeo."
    when :no_video
      path = Rails.application.routes.url_helpers.edit_admin_video_path(self)
      "Please <a href='#{path}'>add a video</a> file to this item.".html_safe
    end
  end

  def human_duration
    if self.duration_in_seconds.to_i > 0
      time_format = self.duration_in_seconds < 3600 ? '%M:%S' : '%H:%M:%S'
      Time.at(self.duration_in_seconds).utc.strftime(time_format)
    end
  end
end