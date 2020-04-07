class ConvertVimeoDataFieldToJson < ActiveRecord::Migration[6.0]
  def up
		change_column :videos, :vimeo_data, :json, using: 'vimeo_data::json'
  end

  def down
  	change_column :videos, :vimeo_data, :text
  end
end
