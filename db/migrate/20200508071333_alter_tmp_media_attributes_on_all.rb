class AlterTmpMediaAttributesOnAll < ActiveRecord::Migration[6.0]
  def change
  	add_column	:downloadables,	:image_tmp_media_id, :integer
  	rename_column	:downloadables,	:tmp_media_id, :file_tmp_media_id
  	rename_column	:audio_files,	:tmp_media_id, :file_tmp_media_id
  	rename_column	:videos,	:tmp_media_id, :tmp_video_file_tmp_media_id
  	rename_column	:lessons,	:tmp_media_id, :thumbnail_tmp_media_id
  	rename_column	:courses,	:tmp_media_id, :image_tmp_media_id
  	rename_column	:users,	:tmp_media_id, :avatar_tmp_media_id
  	rename_column	:authors,	:tmp_media_id, :avatar_tmp_media_id

    add_column  :tmp_media, :resource_attribute, :string
  end
end
