require 'acts_as_commentable_with_threading'
class AddCommentsCountToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :comments_count, :integer, default: 0

    Lesson.reset_column_information
	  Lesson.all.each do |l|
	    Lesson.update_counters l.id, :comments_count => l.comment_count
	  end
  end
end
