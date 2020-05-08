require "administrate/base_dashboard"

class AuthorDashboard < Administrate::BaseDashboard

  ATTRIBUTE_TYPES = {
    lessons: Field::HasMany,
    courses: Field::HasMany,
    name: Field::String,
    referral_registration_url: LinkField,
    referral_home_url: LinkField,
    avatar: ImageField,
    subscription_fee_split: SmallNumberField.with_options(
      searchable: false,
      min: 0,
      max: 100,
      show_percentage: true
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    name
    lessons
    courses
    subscription_fee_split
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    name
    referral_registration_url
    referral_home_url
    subscription_fee_split
    avatar
    lessons
    courses
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    avatar
    subscription_fee_split
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(author)
    author.name
  end

  def permitted_attributes
    [ :id, :name, :avatar_tmp_media_id, :subscription_fee_split ]
  end
end