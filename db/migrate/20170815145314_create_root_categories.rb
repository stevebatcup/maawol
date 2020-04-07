class CreateRootCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :root_categories do |t|
      t.string :name
    end

    add_column :categories, :root_category_id, :integer
  end
end
