require "administrate/base_dashboard"

class SubscriptionOptionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    days: SmallNumberField,
    months: SmallNumberField,
    level: SmallNumberField,
    status: Field::String,
    price: Field::Number.with_options(
      searchable: false,
      decimals: 2,
      prefix: Maawol::Config.currency_symbol,
    ),
    display_sort: SmallNumberField,
    description: Field::Text,
    tag: Field::String,
    name: Field::String,
    payment_system_plan: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    level
    price
    days
    months
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    level
    name
    days
    months
    status
    price
    display_sort
    description
    tag
    payment_system_plan
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    level
    name
    days
    status
    price
    display_sort
    description
    tag
    payment_system_plan
  ].freeze

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

  # Overwrite this method to customize how subscription options are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(subscription_option)
    "Subscription Option"
  end
end