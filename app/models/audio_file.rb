class AudioFile < ApplicationRecord
	belongs_to	:author
	has_and_belongs_to_many :lessons

	validates_presence_of :file

	mount_uploader	:file, AudioFileUploader
end