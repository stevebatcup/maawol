class CreateDownloadableStores < ActiveRecord::Migration[5.2]
  def change
    create_table :downloadable_stores do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :image

      t.timestamps
    end

    add_column	:downloadables, :image, :string, after: :file, default: nil
    add_column  :downloadables, :store_id, :integer, after: :image, default: nil
    add_column	:downloadables, :price, :decimal, :precision => 8, :scale => 2, default: nil, after: :store_id
  end
end
