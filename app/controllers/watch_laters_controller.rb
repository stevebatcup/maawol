class WatchLatersController < MaawolController
	def create
		if WatchLater.create({ user_id: current_user.id, lesson_id: params[:lesson_id] })
			render json: { result: :success }
		else
			render json: { result: :error }
		end
	end

	def destroy
		if @watch_later = WatchLater.find_by(user_id: current_user.id, lesson_id: params[:id])
			@watch_later.destroy
			render json: { result: :success }
		else
			render json: { result: :error }
		end
	end
end