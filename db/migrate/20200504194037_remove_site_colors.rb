class RemoveSiteColors < ActiveRecord::Migration[6.0]
  def change
  	drop_table :site_colors
  end
end
