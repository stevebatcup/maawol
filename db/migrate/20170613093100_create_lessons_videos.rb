class CreateLessonsVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons_videos, id: false do |t|
      t.belongs_to :lesson, index: true
    	t.belongs_to :video, index: true
    end
  end
end
