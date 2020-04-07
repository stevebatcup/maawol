class AddPaypalBillingAgreementIdToUsersSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :users_subscriptions, :paypal_billing_agreement_id, :string
  end
end
