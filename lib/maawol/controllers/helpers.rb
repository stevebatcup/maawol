module Maawol
	module Controllers
		module Helpers
			extend ActiveSupport::Concern

			included do
				helper_method :navbar, :footer_navbar, :current_section, :site_setting, :site_image, :legible_form_errors,
											:cached_course_list, :column_browser_class, :recent_lessons, :results_per_row,
											:is_auth_page?, :results_per_page, :cached_tags, :dynamic_site_colors, :recaptcha_site_key,
											:homepage_video,	:user_signed_in?
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

			def footer_navbar
				Rails.cache.fetch("footer_navbar") do
					ContentManagement::Navbar.includes(:navbar_items)
																	.references(:navbar_items)
																	.where(slug: "footer")
																	.first
				end
			end

			def host
				@host ||= Maawol::Config.site_host
			end

			def site_settings
			  @site_settings ||= Rails.cache.fetch("site_settings") do
			    settings = {}
			    SiteSetting.all.each do |setting|
			      if setting.value.present? && setting.value.length > 0
			        settings[setting.name] = setting.value.html_safe
			      end
			    end
			    settings
			  end
			end

			def site_setting(name)
				site_settings[name] || nil
			end

			def site_images
			  @site_images ||= begin
			    images = {}
			    SiteImage.all.each do |image|
			      if image.image.present? && image.image.url.length > 0
			        images[image.slug] = image.image
			      end
			    end
			    images
			  end
			end

			def site_image(slug)
				site_images[slug] || nil
			end

			def legible_form_errors(errors)
			  errors.full_messages.map { |msg| msg }.first
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
			  		params[:controller].include?('passwords')
			end

			def results_per_row
			  results_per_page / 4
			end

			def results_per_page
				if browser.device.mobile?
					10
				elsif browser.device.tablet?
					21
				else
					12
				end
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