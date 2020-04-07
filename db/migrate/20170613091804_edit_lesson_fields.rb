class EditLessonFields < ActiveRecord::Migration[5.0]
  def change
  	remove_column	:lessons, :video_1_url
  	remove_column	:lessons, :video_2_url
  end
end
