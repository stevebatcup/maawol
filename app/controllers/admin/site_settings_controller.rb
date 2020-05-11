module Admin
  class SiteSettingsController < Admin::ApplicationController
    skip_before_action :verify_authenticity_token

    def valid_action?(name, resource = resource_class)
      %w[show new destroy].exclude?(name.to_s) && super
    end

    def scoped_resource
      SiteSetting.editable.all
    end

    def index
      search_term = params[:search].to_s.strip
      school_settings = Administrate::Search.new(scoped_resource,
                                           dashboard_class,
                                           search_term).run
      school_settings = apply_collection_includes(school_settings)
      school_settings = order.apply(school_settings)
      school_settings = school_settings.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        school_settings: school_settings,
        school_images: SiteImage.all,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
      }
    end

    def update
      sleep(0.5)
      @errors = []
      @status = nil
      case section
      when :basic
        update_settings :basic, %w{ site-name site-easy-name site-blurb }
      when :branding
        update_settings :branding, %w{ theme site-byline }
        update_images :branding, %w{ landscape-logo square-logo email-banner favicon } if @errors.empty?
      when :seo
        update_settings :seo, %w{ twitter-username facebook-page-url instagram-username youtube-channel-id google-analytics-id meta-description }
      when :contact
        update_settings :contact, %w{ contact-email-address }
        update_images :contact, %w{ contact } if @errors.empty?
      end

      if @errors.any?
        render json: { status: :error, error: @errors.first, section: section }
      else
        render  json: { status: :success, section: section }
      end

    end

  private

    def section
      @section ||= params[:id].to_sym
    end

    def update_settings(section, setting_slugs)
      setting_slugs.each do |slug|
        if setting = SiteSetting.find_by(slug: slug)
          unless setting.update(value: params[slug])
            @errors << settings.errors.full_messages.first
          end
        else
          @errors << t("administrate.controller.resources.site_setting.errors.not_found", slug: slug)
        end
      end

      @status = @errors.any? ? :error : :success
    end

    def update_images(section, image_slugs)
      image_slugs.each do |slug|
        if school_image = SiteImage.find_by(slug: slug)
          field_name = "#{slug}-tmp-media-id"
          unless school_image.update(image_tmp_media_id: params[field_name])
            @errors << school_image.errors.full_messages.first
          end
        else
          @errors << t("administrate.controller.resources.site_image.errors.not_found", slug: slug)
        end
      end

      @status = @errors.any? ? :error : :success
    end
  end
end