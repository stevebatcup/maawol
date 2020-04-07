class CreateCmsPages < ActiveRecord::Migration[5.2]
  def change
    create_table :cms_pages do |t|
      t.string :title
      t.string :slug
      t.boolean :is_editable, default: false

      t.timestamps
    end
  end
end
