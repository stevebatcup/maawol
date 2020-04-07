module Admin
	module ContentManagement
		class NavbarsController < Admin::ApplicationController
			def edit
				@requested_resource = ::ContentManagement::Navbar.find_by(slug: params[:slug])
				super
			end

			def update
			  if requested_resource.update(resource_params)
			    redirect_to(
			      admin_content_management_edit_navbar_path(slug: requested_resource.slug),
			      notice: translate_with_resource("update.success"),
			    )
			  else
			    render :edit, locals: {
			      page: Administrate::Page::Form.new(dashboard, requested_resource),
			    }
			  end
			end
		end
	end
end