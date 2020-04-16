require "administrate/base_dashboard"

class ProductPaymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user_name: Field::String,
    user_email: Field::String,
    item_name: Field::String,
    item_type: Field::String,
    author_name: Field::String,
    author_fee: Field::Number.with_options(
      decimals: 2,
      prefix: Maawol::Config.currency_symbol,
      searchable: false
    ),
    amount: Field::Number.with_options(
      searchable: false,
      prefix: Maawol::Config.currency_symbol,
      decimals: 2
    ),
    status: Field::String,
    payment_system: Field::String,
    email: Field::String,
    first_name: Field::String,
    last_name: Field::String,
    processed_at: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user_name
    item_name
    item_type
    amount
    status
    processed_at
    payment_system
    author_name
    author_fee
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    user_name
    user_email
    processed_at
    item_name
    item_type
    amount
    author_name
    author_fee
    status
    payment_system
    first_name
    last_name
    email
    payment_system
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  #
  # def display_resource(productable_payment)
  #   "productablePayment ##{productable_payment.id}"
  # end
end