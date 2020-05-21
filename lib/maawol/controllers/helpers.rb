module Maawol
	module Controllers
		module Helpers
			extend ActiveSupport::Concern

			included do
				helper_method :navbar, :signed_in_nav_items, :footer_navbar_items, :current_section, :school_setting, :school_image, :legible_form_errors,
											:cached_course_list, :column_browser_class, :recent_lessons, :results_per_row,
											:is_auth_page?, :results_per_page, :cached_tags, :dynamic_site_colors, :recaptcha_site_key,
											:homepage_video,	:user_signed_in?, :is_settings_page?, :site_theme, :use_recaptcha?,
											:show_subscription_interstitial?, :show_subscription_nav_button?
			end

			def navbar
				nav_slugs = [user_signed_in? ? :signed_in : :signed_out, browser.device.mobile? ? :mobile : :desktop]
				Rails.cache.fetch("navbar_#{nav_slugs.join("_")}") do
					n = ContentManagement::Navbar.includes(:navbar_items)
																	.references(:navbar_items)
																	.where(slug: nav_slugs[0])
																	.where(cms_navbar_items: { nav_slugs[1] => true })
																	.first
				end
			end

			def signed_in_nav_items
				RootCategory.includes(:categories).where.not(categories: {id: nil})
			end

			def footer_navbar_items
				ContentManagement::Page.footer_navbar_items
			end

			def host
				@host ||= Maawol::Config.site_host
			end

			def school_settings
			  @school_settings ||= Rails.cache.fetch("school_settings") do
			    items = {}
			    SiteSetting.all.each do |setting|
			      if setting.value.present? && setting.value.length > 0
			        items[setting.slug] = setting.value.html_safe
			      end
			    end
			    items
			  end
			end

			def school_setting(slug)
				school_settings[slug] || nil
			end

			def school_images
			  @school_images ||= begin
			    images = {}
			    SiteImage.all.each do |image|
			      if image.image.present? && image.image.url.length > 0
			        images[image.slug] = image.image
			      end
			    end
			    images
			  end
			end

			def school_image(slug)
				school_images[slug] || nil
			end

			def legible_form_errors(errors)
			  errors.values.first.first
			end

			def main_error_field(errors)
				errors.keys.first.to_s.camelize(:lower)
			end

			def column_browser_class
			  browser.device.mobile? ? 'column-2' : 'column-3'
			end

			def cached_course_list
			  Rails.cache.fetch("course_list") { Course.published.where("include_in_menu > 0").limit(5).order(:include_in_menu) }
			end

			def recent_lessons(limit=3)
			  @recent_lessons ||= Lesson.where(course_only: false).published.order(publish_date: :desc).limit(limit)
			end

			def is_auth_page?
			  params[:controller].include?('clearance') ||
			  	params[:controller].include?('sessions') ||
			  		params[:controller].include?('passwords') ||
			  			params[:controller].include?('users') ||
			  				(params[:controller].include?('checkout') && params[:action] == 'new')
			end

			def is_settings_page?
				params[:controller].include?('settings')
			end

			def site_theme
				school_setting("theme")
			end

			def use_recaptcha?
				if signed_in?
					false
				else
					Rails.env.production?
				end
			end

			def show_subscription_interstitial?
				signed_in? &&
					!current_user.has_full_account? &&
						!current_user.is_admin? &&
							!params[:controller].include?('subscriptions')
			end

			def show_subscription_nav_button?
				show_subscription_interstitial?
			end

			def results_per_row
			  results_per_page / 4
			end

			def results_per_page
				browser.device.mobile? ? 10 : 12
			end

			def basket
				@basket ||= begin
					if params[:paymentId] && params[:token] && params[:PayerID] # grab basket for paypal return
						Basket.find_by(paypal_payment_id: params[:paymentId])
					elsif session[:basket_id]
						Basket.find(session[:basket_id])
					else
						b = Basket.create
						session[:basket_id] = b.id
						b
					end
				end
			end

			def cached_tags
				@cached_tags ||= Rails.cache.fetch("cached_tags") { Tag.for_cloud.limit(15) }
			end

			def dynamic_site_colors
				@dynamic_site_colors ||= begin
					list = {}
					SiteColor.all.each { |site_color| list[site_color.slug.to_sym] = site_color.value }
					list
				end
			end

			def recaptcha_site_key
				Maawol::Config.recaptcha_site_key
			end

			def recaptcha_secret_key
				Maawol::Config.recaptcha_secret_key
			end

			def homepage_video
				@homepage_video ||= Video.find_by(is_for_homepage: true)
			end

			def user_signed_in?
				signed_in?
			end

			def user_redirect_url
				Clearance.configuration.redirect_url
			end
		end
	end
end