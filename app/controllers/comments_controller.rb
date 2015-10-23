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

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.where(creator: current_user, voteable: @comment).first  # get the users existing vote (if exists)

    if @vote  # if user has already vote on this object, update existing vote
      @vote.update(vote: params[:vote], creator: current_user, voteable: @comment)
    else  # create new vote if no existing vote
      @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)
    end

    flash[:notice] = "Your vote was registered!"
    redirect_to :back
  end
end
