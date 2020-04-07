class CreateContentManagementNavBarItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cms_navbar_items do |t|
      t.integer :navbar_id
      t.string :name
      t.string :url
      t.integer :sort

      t.timestamps
    end
  end
end
