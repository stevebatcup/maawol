module Admin
	module ApplicationHelper
		include Administrate::ApplicationHelper

		def	remove_prefixes_from_displayed_name(resource_name)
			resource_name.split("/").last.capitalize
		end

		def display_resource_name(resource_name)
			resource_name = super(resource_name)
			remove_prefixes_from_displayed_name(resource_name)
		end
	end
end