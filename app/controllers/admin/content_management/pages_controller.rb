module Admin
	module ContentManagement
		class PagesController < Admin::ApplicationController
			def scoped_resource
				::ContentManagement::Page.where(is_editable: true)
			end

			def create
				resource = resource_class.new(resource_params)
				resource.is_editable = true
				authorize_resource(resource)

				if resource.save
				  redirect_to(
				    [namespace, resource],
				    notice: translate_with_resource("create.success"),
				  )
				else
				  render :new, locals: {
				    page: Administrate::Page::Form.new(dashboard, resource),
				  }
				end
			end
		end
	end
end