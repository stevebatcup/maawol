require "administrate/base_dashboard"

class UsersSubscriptionPaymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::String,
    amount: Field::Number.with_options(
      decimals: 2,
      prefix: "$",
      searchable: false
    ),
    status: Field::String,
    processed_at: Field::String,
    first_payment: Field::Boolean,
    author_fee: Field::Number.with_options(
      decimals: 2,
      prefix: "$",
      searchable: false
    ),
    author_name: Field::String
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    user
    processed_at
    amount
    status
    first_payment
    author_name
    author_fee
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    user
    processed_at
    amount
    status
    first_payment
    author_name
    author_fee
  ].freeze

  FORM_ATTRIBUTES = %i[].freeze
  COLLECTION_FILTERS = {}.freeze


  # def display_resource(users_subscription_payment)
  #   "UsersSubscriptionPayment ##{users_subscription_payment.id}"
  # end
end