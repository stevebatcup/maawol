module Admin
  class SiteSettingsController < Admin::ApplicationController
    def valid_action?(name, resource = resource_class)
      %w[show new destroy].exclude?(name.to_s) && super
    end

    def scoped_resource
      SiteSetting.editable.all
    end

    def index
      search_term = params[:search].to_s.strip
      site_settings = Administrate::Search.new(scoped_resource,
                                           dashboard_class,
                                           search_term).run
      site_settings = apply_collection_includes(site_settings)
      site_settings = order.apply(site_settings)
      site_settings = site_settings.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        site_settings: site_settings,
        site_images: SiteImage.all,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
      }
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