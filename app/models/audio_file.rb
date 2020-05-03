class AudioFile < ApplicationRecord
  include Maawol::Models::Concerns::Productable

	belongs_to	:author
	has_and_belongs_to_many :lessons

	validates_presence_of :file

	mount_uploader	:file, AudioFileUploader

  before_save :set_token

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
		# ActionController::Base.helpers.asset_path "no-avatar.png"
		false
	end
end