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
    @vote = Vote.find_by(creator: current_user, voteable: @comment)  # get the users existing vote (if exists)

    if @vote  # if user has already vote on this object, update existing vote
      @vote.update(vote: params[:vote], creator: current_user, voteable: @comment)
      @message_text = "Vote updated!"
    else  # create new vote if no existing vote
      @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)
      @message_text = "Vote received!"
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
