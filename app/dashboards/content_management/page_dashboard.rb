require "administrate/base_dashboard"

module ContentManagement
	class PageDashboard < Administrate::BaseDashboard
    # ATTRIBUTE_TYPES
    # a hash that describes the type of each of the model's fields.
    #
    # Each different type represents an Administrate::Field object,
    # which determines how the attribute is displayed
    # on pages throughout the dashboard.
    ATTRIBUTE_TYPES = {
    	title: Field::String,
    	url: LinkField,
    	slug: Field::String,
    	url: Field::String,
    	sections: NestedContentField,
    	created_at: Field::DateTime,
    	updated_at: Field::DateTime,
    }.freeze
     # hint: "This will be the URL to your page. Leave blank to auto-generate."

    # COLLECTION_ATTRIBUTES
    # an array of attributes that will be displayed on the model's index page.
    #
    # By default, it's limited to four items to reduce clutter on index pages.
    # Feel free to add, remove, or rearrange items.
    COLLECTION_ATTRIBUTES = %i[
    	title
    	url
    	sections
    ].freeze

    # SHOW_PAGE_ATTRIBUTES
    # an array of attributes that will be displayed on the model's show page.
    SHOW_PAGE_ATTRIBUTES = %i[
    	title
    	url
    	sections
    ].freeze

    # FORM_ATTRIBUTES
    # an array of attributes that will be displayed
    # on the model's form (`new` and `edit`) pages.
    FORM_ATTRIBUTES = %i[
    	title
    	slug
    	sections
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

    # Overwrite this method to customize how pages are displayed
    # across all pages of the admin dashboard.
    #
    def display_resource(page)
    	"Page"
    end

    def permitted_attributes
    	[ :id, :title, :slug, sections_attributes: [:id, :content_block_id, :sort, :_destroy ] ]
    end
  end
end