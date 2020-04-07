class FavouritesController < MaawolController
	def create
		if Favourite.create({ user_id: current_user.id, lesson_id: params[:lesson_id] })
			render json: { result: :success }
		else
			render json: { result: :error }
		end
	end

	def destroy
		if @favourite = Favourite.find_by(user_id: current_user.id, lesson_id: params[:id])
			@favourite.destroy
			render json: { result: :success }
		else
			render json: { result: :error }
		end
	end
end