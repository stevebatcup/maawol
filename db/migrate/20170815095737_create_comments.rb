class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :lesson_id
      t.text :content
      t.timestamps
    end

    add_index	:comments, :user_id

    create_table :comments_lessons, id: false do |t|
    	t.belongs_to :comment, index: true
      t.belongs_to :lesson, index: true
    end
  end
end
