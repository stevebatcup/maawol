require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    first_name: Field::String,
    last_name: Field::String,
    username: Field::String,
    email: Field::String,
    created_at: Field::DateTime,
    is_admin: Field::Boolean,
    status: MemberStatusField,
    subscription_status: SubscriptionStatusField,
    subscription_created: Field::String,
    avatar: ImageField,
    subscription_referring_author_name: Field::String,
    author: Field::BelongsTo
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :first_name,
    :last_name,
    :status,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :status,
    :is_admin,
    :created_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :status,
    :subscription_status,
    :avatar,
    :is_admin,
    :author
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.full_name}"
  end
end