module ContentManagement
	class PagesController < MaawolController
		def show
			@page = Page.find_by(slug: params[:slug])
			render_404 unless @page
		end
	end
end