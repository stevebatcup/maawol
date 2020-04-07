class AddEncryptedPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
		remove_column	:users, :password, :string
		add_column	:users, :encrypted_password, :string, after: :email
	end
end
