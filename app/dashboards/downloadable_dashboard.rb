require "administrate/base_dashboard"

class DownloadableDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    file: DownloadableField,
    image: ImageField.with_options(
      hint: I18n.t('administrate.hints.resources.downloadable.image'),
    ),
    author: Field::BelongsTo.with_options(scope: -> { Author.order(id: :asc) }),
    full_url: Field::String,
    basket_url: Field::String,
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
    :author
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :file,
    :image,
    :author,
    :full_url,
    :basket_url
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :file,
    :image,
    :author,
  ].freeze

  # Overwrite this method to customize how downloadables are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(downloadable)
    downloadable.name
  end

  def permitted_attributes
    [ :id, :name, :image_tmp_media_id, :file_tmp_media_id, :author_id ]
  end
end