class RenameSiteImagesTmpMediaIa < ActiveRecord::Migration[6.0]
  def change
  	rename_column	:site_images, :tmp_media_id, :image_tmp_media_id
  end
end
