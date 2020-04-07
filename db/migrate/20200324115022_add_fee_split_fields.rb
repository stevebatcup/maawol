class AddFeeSplitFields < ActiveRecord::Migration[5.2]
  def change
  	add_column	:products, :author_fee_split, :int, after: :price, default: 0
  end
end
