class CommentsController < MaawolController
  def create
    if signed_in?
      article = Lesson.find(params[:comment][:article_id]) if params[:comment][:article_type] == 'Lesson'
      comment = Comment.build_from(article, current_user.id, params[:comment][:body])
      if comment.save
        parent_id = params[:comment][:parent].to_i
        @comment = view_context.comment_for_mustache(comment, parent_id == 0)
        comment.move_to_child_of Comment.find(parent_id) if parent_id > 0
        @comment[:status] = :success
      else
        @comment = { status: :error, message: legible_form_errors(comment.errors) }
      end
    else
      @comment = { status: :error, message: "You must be signed in to make a comment" }
    end
  end
end
