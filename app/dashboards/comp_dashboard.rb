require "administrate/base_dashboard"

class CompDashboard < UserDashboard

  COLLECTION_ATTRIBUTES = [
    :first_name,
    :last_name,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :status,
    :created_at,
  ].freeze

  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :status,
    :is_admin,
  ].freeze
end