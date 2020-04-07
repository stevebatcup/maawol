class AddSubscriptionFeeSplitToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :subscription_fee_split, :int, after: :referral_token
  end
end
