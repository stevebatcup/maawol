class CreateIncomeReports < ActiveRecord::Migration[6.0]
  def change
    create_table :income_reports do |t|
      t.integer :month
      t.integer :year
      t.integer :subscription_payments_count
      t.decimal :subscription_payments_total, :precision => 8, :scale => 2
      t.integer :store_payments_count
      t.decimal :store_payments_total, :precision => 8, :scale => 2
      t.decimal :total_income, :precision => 8, :scale => 2
      t.integer :profit_split_percentage
      t.decimal :earnings, :precision => 8, :scale => 2
      t.integer :status
      t.text :payment_notes
      t.date :paid_on

      t.timestamps
    end
  end
end
