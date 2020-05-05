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

		def angular_controller(resource_name)
			"Admin#{resource_name.gsub('/', '_').pluralize.camelcase}Controller"
		end

		def locked_lesson_redirect_path
			if signed_in?
				"/subscribe?from=locked_lesson"
			else
				"/sign_up?from=locked_lesson"
			end
		end
	end
end