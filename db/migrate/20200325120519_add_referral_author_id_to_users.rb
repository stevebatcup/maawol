class AddReferralAuthorIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :referral_author_id, :int
  end
end
