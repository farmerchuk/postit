class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment was successfully created!"
      redirect_to @post
    else
      @post.comments.reload # drops the incomplete comment before re-rendering
      render "posts/show"
    end
  end
end
