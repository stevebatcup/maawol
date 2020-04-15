class LessonsUsers < ActiveRecord::Migration[6.0]
  def change
  	create_table :lessons_users, id: false do |t|
  	  t.belongs_to :lesson, index: true
  		t.belongs_to :user, index: true
  	end

  	add_column	:lessons, :access_level, :integer, default: 0
  end
end
