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

		def help_image_tag(help_section, width='100%')
			image_tag("https://maawol.s3.amazonaws.com/admin-help/screenshots/#{help_section}.png",
									class: 'admin_help_screenshot d-block mb-2',
									width: width)
		end
	end
end