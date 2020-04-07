class CreateCmsContentBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :cms_content_blocks do |t|
      t.string :title
      t.text :content
      t.boolean :is_editable, default: false

      t.timestamps
    end
  end
end
