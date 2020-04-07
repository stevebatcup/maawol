class LinkListeningLabsToLessons < ActiveRecord::Migration[5.0]
  def change
  	create_table :lessons_listening_labs, id: false do |t|
      t.belongs_to :lesson, index: true
    	t.belongs_to :listening_lab, index: true
    end
  end
end
