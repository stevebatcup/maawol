class AddNameFieldsToDownloadablePayments < ActiveRecord::Migration[5.2]
  def change
  	remove_column	:downloadable_payments, :user_email, :string
    add_column :downloadable_payments, :payment_system, :string, after: :status
    add_column :downloadable_payments, :email, :string, after: :payment_system
    add_column :downloadable_payments, :first_name, :string, after: :email
    add_column :downloadable_payments, :last_name, :string, after: :first_name
  end
end
