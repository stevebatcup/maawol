class AddSlugToCmsContentBlocks < ActiveRecord::Migration[6.0]
  def change
    add_column :cms_content_blocks, :is_deletable, :boolean, default: true
    add_column :cms_content_blocks, :slug, :string
  end
end
