class AddPublishDateToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :publish_date, :datetime
    add_index	:lessons, :publish_date
  end
end
