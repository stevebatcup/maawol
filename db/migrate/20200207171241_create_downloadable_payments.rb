class CreateDownloadablePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :downloadable_payments do |t|
      t.integer :downloadable_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :status
      t.string	:user_email

      t.timestamps
    end
  end
end
