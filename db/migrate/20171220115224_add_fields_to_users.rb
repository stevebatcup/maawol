class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :user_id
    end

    add_column :users, :username, :string
    add_column :users, :email, :string
    add_column :users, :avatar, :string
  end
end
