module Admin
  class SiteSettingsController < Admin::ApplicationController
    def valid_action?(name, resource = resource_class)
      %w[show new destroy].exclude?(name.to_s) && super
    end

    def update
      if requested_resource.update(resource_params)
        redirect_to("/admin/site_settings", notice: "Setting updated")
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end

  end
end