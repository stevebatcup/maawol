class AddWidthAndHeightToSiteImages < ActiveRecord::Migration[6.0]
  def change
    add_column :site_images, :width, :int
    add_column :site_images, :height, :int
  end
end
