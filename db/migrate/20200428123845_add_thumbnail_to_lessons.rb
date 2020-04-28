class AddThumbnailToLessons < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :thumbnail, :string
  end
end
