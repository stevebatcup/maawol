class CreateApiLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :api_logs do |t|
      t.integer :user_id
      t.string :service
      t.string :request_type
      t.string :request_method
      t.text :request_data
      t.text :response

      t.timestamps
    end

    add_index :api_logs, :user_id
    add_index :api_logs, :service
  end
end
