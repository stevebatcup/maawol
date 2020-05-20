module Admin
	module SettingsHelper
		include Administrate::ApplicationHelper

		def render_setting_string_field(attribute_name, page, resource, locals = {})
			field = Administrate::Field::String.new(attribute_name, resource.value, page, resource: resource)
		  locals.merge!(field: field, value: resource.value)
		  render locals: locals, partial: "/fields/site_settings/string"
		end

		def render_setting_price_field(attribute_name, page, resource, locals = {})
			field = Administrate::Field::Number.new(attribute_name, resource.value, page, { resource: resource, decimals: 2 })
		  locals.merge!(field: field, value: resource.value)
		  render locals: locals, partial: "/fields/site_settings/price"
		end

		def render_setting_email_field(attribute_name, page, resource, locals = {})
			field = Administrate::Field::Email.new(attribute_name, resource.value, page, resource: resource)
		  locals.merge!(field: field, value: resource.value)
		  render locals: locals, partial: "/fields/site_settings/email"
		end

		def render_setting_text_field(attribute_name, page, resource, use_tinymce=true, locals = {})
			field = TinyMceField.new(attribute_name, resource.value, page, resource: resource)
		  locals.merge!(field: field, value: resource.value, use_tinymce: use_tinymce)
		  render locals: locals, partial: "/fields/site_settings/text"
		end

		def render_setting_select_field(attribute_name, page, resource, options, locals = {})
			field = Administrate::Field::Select.new(attribute_name, resource.value, page, { resource: resource, collection: options })
		  locals.merge!(field: field, value: resource.value)
		  render locals: locals, partial: "/fields/site_settings/select"
		end

		def render_setting_image_field(attribute_name, page, resource, size=:smalll_square, locals = {})
			field = ImageField.new(attribute_name, resource.image, page, resource: resource)
		  locals.merge!(field: field, value: resource.image, size: size)
		  render locals: locals, partial: "/fields/site_settings/image"
		end
	end
end