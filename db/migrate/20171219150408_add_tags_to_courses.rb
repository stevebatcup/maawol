class AddTagsToCourses < ActiveRecord::Migration[5.0]
  def change
	  create_table :courses_tags, id: false do |t|
	  	t.belongs_to :course, index: true
	    t.belongs_to :tag, index: true
	  end
  end
end
