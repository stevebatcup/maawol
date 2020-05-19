class AddSlugToRootCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :root_categories, :slug, :string
  end
end
