class AddCoverToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :cover, :string
  end
end
