class BuildCoursesLessons < ActiveRecord::Migration[5.0]
  def change
  	drop_table	:courses_lessons

  	create_table :teachings do |t|
  		t.belongs_to	:course, index: true
  		t.belongs_to	:lesson, index: true
  		t.integer	:sort
  		t.text :description
  		t.timestamps
  	end
  end
end
