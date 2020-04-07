class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :video_1_url
      t.string :video_2_url
      t.boolean :course_only

      t.timestamps
    end
  end
end
