class ChangeStoreToDownloadsRelationship < ActiveRecord::Migration[5.2]
  def change
  	remove_column	:downloadables, :store_id, :integer, after: :image
    remove_column :downloadables, :price, :decimal, :precision => 8, :scale => 2, default: nil

  	create_table :products do |t|
  		t.belongs_to	:downloadable_store, index: true
  		t.belongs_to	:downloadable, index: true
  		t.integer	:sort
      t.decimal :price, :precision => 8, :scale => 2, default: nil
  		t.timestamps
  	end
  end
end
