class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.string :artist
      t.string :url

      t.timestamps
    end

    create_table :albums_listening_labs, id: false do |t|
      t.belongs_to :album, index: true
    	t.belongs_to :listening_lab, index: true
    end
  end
end
