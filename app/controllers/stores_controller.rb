class StoresController < MaawolController
	def show
		@store = Store.find_by(slug: params[:slug])
		render_404 unless @store
	end
end