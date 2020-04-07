class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :courses_lessons, id: false do |t|
    	t.belongs_to :course, index: true
      t.belongs_to :lesson, index: true
    end
  end
end
