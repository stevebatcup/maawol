class CreateStuckAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :stuck_answers do |t|
      t.integer :stuck_question_id
      t.text :answer
      t.integer :sort

      t.timestamps
    end
  end
end
