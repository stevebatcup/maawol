class AdaptStoreForMultiProducts < ActiveRecord::Migration[5.2]
  def change
  	remove_column	:products, :downloadable_id, :integer
  	rename_column	:products, :downloadable_store_id, :store_id
  	add_column	:products, :productable_id, :bigint, after: :store_id
  	add_column	:products, :productable_type, :string, after: :productable_id

  	rename_table	:downloadable_stores, :stores
  end
end
