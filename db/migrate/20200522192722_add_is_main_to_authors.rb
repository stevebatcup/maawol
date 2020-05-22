class AddIsMainToAuthors < ActiveRecord::Migration[6.0]
  def change
    add_column :authors, :is_main, :boolean, default: false
  end
end
