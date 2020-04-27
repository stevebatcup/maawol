require "administrate/base_dashboard"

class LessonDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name: Field::String,
    human_access_level: NonEditableStringField,
    videos: AttachableField,
    downloadables: AttachableField,
    tags: HasLotsField,
    author: Field::BelongsTo.with_options(scope: -> { Author.order(id: :asc) }),
    categories: HasLotsField,
    content: TinyMceField,
    course_only: Field::Boolean,
    is_free: Field::Boolean,
    playlists: HasLotsField,
    users: HasLotsField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    publish_date: Field::DateTime.with_options(
      format: "%b %d, %Y"
    )
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :author,
    :is_free,
    :human_access_level,
    :publish_date
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :author,
    :content,
    :course_only,
    :human_access_level,
    :publish_date,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :author,
    :videos,
    :downloadables,
    :content,
    :course_only,
    :is_free,
    :tags,
    :categories,
    :playlists,
    :users,
    :publish_date
  ].freeze

  # Overwrite this method to customize how lessons are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(lesson)
    "#{lesson.name}"
  end
end