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
    human_access_level: NonEditableStringField.with_options( searchable: false ),
    videos: AttachableField,
    audio_files: AttachableField,
    downloadables: AttachableField,
    thumbnail: ImageField.with_options(
      hint: I18n.t('administrate.hints.resources.lesson.thumbnail'),
    ),
    tags: HasLotsField,
    author: Field::BelongsTo.with_options(scope: -> { Author.order(id: :asc) }),
    categories: HasLotsField,
    content: TinyMceField,
    course_only: Field::Boolean,
    is_free: Field::Boolean,
    playlists: HasLotsField,
    users: AttachableField.with_options(
      hint: I18n.t('administrate.hints.resources.lesson.users'),
    ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    publish_date: Field::Date.with_options(
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
    :publish_date,
    :course_only,
    :human_access_level,
    :thumbnail,
    :content,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :author,
    :publish_date,
    :videos,
    :audio_files,
    :downloadables,
    :tags,
    :categories,
    :playlists,
    :users,
    :thumbnail,
    :content,
    :course_only,
    :is_free,
  ].freeze

  # Overwrite this method to customize how lessons are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(lesson)
    "#{lesson.name}"
  end

  def permitted_attributes
    [ :id, :name, :thumbnail_tmp_media_id, :author_id, :publish_date, :content,
          :course_only, :is_free, video_ids: [],
          audio_file_ids: [], downloadable_ids: [], tag_ids: [],
          category_ids: [], playlist_ids: [], user_ids: [] ]
  end

end