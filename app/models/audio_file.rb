class AudioFile < ApplicationRecord
  include Maawol::Models::Concerns::Productable
  include Maawol::Models::Concerns::TmpUploadable

	belongs_to	:author
	has_and_belongs_to_many :lessons

	mount_uploader	:file, AudioFileUploader

	validates_presence_of :name, :author_id

  before_save :set_token
  after_save	:migrate_file_from_tmp_upload, if: -> { self.file_tmp_media_id.present? }

	def field_for_upload
		:file
	end

  def id_for_admin_selector
    "audio_file_#{self.id}"
  end

	def name_for_admin_selector
	  "Audio file: #{self.name}"
	end

	def name_with_type
	  "#{self.name} audio file"
	end

	def has_image?
		false
	end
end