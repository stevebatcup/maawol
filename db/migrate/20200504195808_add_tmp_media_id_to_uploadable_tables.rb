class AddTmpMediaIdToUploadableTables < ActiveRecord::Migration[6.0]
  def change
  	add_column	:authors, :tmp_media_id, :integer
  	add_column	:audio_files, :tmp_media_id, :integer
  	add_column	:users, :tmp_media_id, :integer
  	add_column	:courses, :tmp_media_id, :integer
  	add_column	:downloadables, :tmp_media_id, :integer
  	add_column	:lessons, :tmp_media_id, :integer
  	add_column	:site_images, :tmp_media_id, :integer
  	add_column	:stores, :tmp_media_id, :integer
  	add_column	:videos, :tmp_media_id, :integer
  end
end
