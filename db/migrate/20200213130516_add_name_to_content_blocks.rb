class AddNameToContentBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :cms_content_blocks, :name, :string, after: :id
  end
end
