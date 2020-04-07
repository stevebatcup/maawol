class RemoveCommentsLessons < ActiveRecord::Migration[5.0]
  def change
  	drop_table	:comments_lessons
  end
end
