require "administrate/base_dashboard"

class IncomeReportDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    month_and_year: Field::String,
    subscription_payments_count: Field::Number.with_options(
      searchable: false
    ),
    subscription_payments_total: Field::Number.with_options(
      searchable: false,
      decimals: 2,
      prefix: "$",
    ),
    store_payments_count: Field::Number.with_options(
      searchable: false,
    ),
    store_payments_total: Field::Number.with_options(
      searchable: false,
      decimals: 2,
      prefix: "$",
    ),
    total_income: Field::Number.with_options(
      searchable: false,
      decimals: 2,
      prefix: "$",
    ),
    earnings: Field::Number.with_options(
      searchable: false,
      decimals: 2,
      prefix: "$",
    ),
    profit_split_percentage: SmallNumberField.with_options(
      searchable: false,
      show_percentage: true
    ),
    paid_on: Field::Date,
    status: Field::String,
    payment_notes: Field::Text,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :month_and_year,
    :store_payments_count,
    :subscription_payments_count,
    :total_income,
    :earnings,
    :status
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :month_and_year,
    :total_income,
    :store_payments_count,
    :store_payments_total,
    :subscription_payments_count,
    :subscription_payments_total,
    :profit_split_percentage,
    :total_income,
    :earnings,
    :status,
    :paid_on,
    :payment_notes
  ].freeze

  FORM_ATTRIBUTES = [].freeze

  def display_resource(report)
    "#{report.month_and_year} report"
  end
end