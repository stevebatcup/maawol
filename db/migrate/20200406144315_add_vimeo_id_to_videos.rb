class AddVimeoIdToVideos < ActiveRecord::Migration[6.0]
  def change
  	add_column	:videos, :vimeo_id, :string, after: :url
  end
end
