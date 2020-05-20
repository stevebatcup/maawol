class CreateLessonRecommendations < ActiveRecord::Migration[6.0]
  def change
    create_table :lesson_recommendations do |t|
      t.integer :recommender_lesson_id
      t.integer :recommended_lesson_id

      t.timestamps
    end
  end
end
