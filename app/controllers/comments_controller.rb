class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = User.first

    if @comment.save
      flash[:notice] = "Your comment was successfully created!"
      redirect_to @post
    else
      render "posts/show"
    end
  end
end
