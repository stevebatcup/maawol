module Admin
	module ContentManagement
		class ContentBlocksController < Admin::ApplicationController
			def scoped_resource
				if params[:page_id]
					page = ::ContentManagement::Page.find(params[:page_id])
					page.content_blocks
				else
					::ContentManagement::ContentBlock.where(is_editable: true)
				end
			end
		end
	end
end