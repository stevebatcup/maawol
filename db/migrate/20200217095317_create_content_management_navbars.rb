class CreateContentManagementNavbars < ActiveRecord::Migration[5.2]
  def change
    create_table :cms_navbars do |t|
      t.string :slug

      t.timestamps
    end
  end
end
