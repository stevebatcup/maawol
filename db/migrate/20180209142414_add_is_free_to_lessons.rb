class AddIsFreeToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :is_free, :boolean, default: false
  end
end
