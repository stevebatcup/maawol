class CreateSiteColors < ActiveRecord::Migration[5.2]
  def change
    create_table :site_colors do |t|
      t.string :name
      t.string :slug
      t.string :value
      t.string :default_value

      t.timestamps
    end
  end
end
