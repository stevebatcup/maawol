require "administrate/base_dashboard"

class PlaylistDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    lessons: Field::HasMany,
    name: Field::String,
    spotify_url: Field::String,
    apple_music_url: Field::String,
    amazon_music_url: Field::String,
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
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :spotify_url,
    :apple_music_url,
    :amazon_music_url
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :spotify_url,
    :apple_music_url,
    :amazon_music_url
  ].freeze

  # Overwrite this method to customize how playlists are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(playlist)
    playlist.name
  end
end