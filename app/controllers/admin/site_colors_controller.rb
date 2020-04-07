module Admin
	class SiteColorsController < Admin::ApplicationController
		def edit
			@colors = SiteColor.order(:id)
		end

		def update
			params[:colors].each do |slug, new_color|
				if site_color = SiteColor.find_by(slug: slug)
					site_color.update_attribute(:value, new_color)
				end
			end

			flash[:notice] = "Colors updated"
			redirect_to admin_site_colors_path
		end
	end
end