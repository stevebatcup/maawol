require "administrate/base_dashboard"

class SubscriberDashboard < UserDashboard

  COLLECTION_ATTRIBUTES = [
    :first_name,
    :last_name,
    :subscription_created,
    :subscription_referring_author_name
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :status,
    :subscription_created,
    :created_at,
    :is_admin,
    :current_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_at,
    :last_sign_in_ip,
  ].freeze

  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :status,
    :subscription_status,
    :is_admin,
  ].freeze
end