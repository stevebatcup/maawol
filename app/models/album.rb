class Album < ApplicationRecord
	has_and_belongs_to_many	:listening_labs
	validates_presence_of :name
	mount_uploader :cover, AlbumCoverUploader
end