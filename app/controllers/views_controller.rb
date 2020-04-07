class ViewsController < MaawolController
	def create
		if View.create({ user_id: current_user.id, lesson_id: params[:lesson_id] })
			render json: { result: :success }
		else
			render json: { result: :error }
		end
	end

	def destroy
		if @view = View.find_by(user_id: current_user.id, lesson_id: params[:id])
			@view.destroy
			render json: { result: :success }
		else
			render json: { result: :error }
		end
	end
end