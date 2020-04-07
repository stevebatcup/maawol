class CommentsController < MaawolController
	def create
		if params[:comment][:article_type] == "Lesson"
			article = Lesson.find(params[:comment][:article_id])
		end
		comment = Comment.build_from(article, current_user.id, params[:comment][:body])
		if comment.save
			parent_id = params[:comment][:parent].to_i
			@comment = view_context.comment_for_mustache(comment, parent_id == 0)
			comment.move_to_child_of Comment.find(parent_id) if parent_id > 0
			@comment[:status] = :success
		else
			@comment = { status: :error, message: "Could not create comment" }
		end
	end
end