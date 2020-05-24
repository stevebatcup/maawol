require "administrate/base_dashboard"

class CourseDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    author: Field::BelongsTo.with_options(scope: -> { Author.order(id: :asc) }),
    image: ImageField.with_options(
      hint: I18n.t('administrate.hints.resources.course.image'),
    ),
    description: TinyMceField,
    teachings: NestedLessonField,
    lessons: Field::HasMany,
    skill_levels: HasLotsField,
    tags: HasLotsField,
    categories: HasLotsField,
    publish_date: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :teachings,
    :author,
    :publish_date
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :author,
    :image,
    :description,
    :lessons,
    :publish_date
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :author,
    :image,
    :skill_levels,
    :tags,
    :teachings,
    :publish_date,
    :description,
  ].freeze

  # Overwrite this method to customize how courses are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(course)
    course.name.nil? ? "" : "Course '#{course.name}'"
  end

  def permitted_attributes
    [ :id, :image_tmp_media_id, :name, :author_id, :image, :description, :publish_date, skill_level_ids: [], tag_ids: [], category_ids: [], teachings_attributes: [:id, :lesson_id, :sort, :description, :_destroy ] ]
  end
end