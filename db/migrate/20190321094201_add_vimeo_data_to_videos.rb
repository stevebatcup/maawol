class AddVimeoDataToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :vimeo_data, :text
  end
end
