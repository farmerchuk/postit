class PostsController < ApplicationController
  POSTS_PER_PAGE = 5

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user_or_admin, only: [:edit, :update]

  def index
    posts = Post.all.sort_by { |obj| obj.total_votes }.reverse
    @pages = (posts.size.to_f / POSTS_PER_PAGE).ceil
    @current_page = (params[:offset].to_i / POSTS_PER_PAGE) + 1
    @posts = posts[params[:offset].to_i, POSTS_PER_PAGE]
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was successfully created!"
      redirect_to post_path(@post)  # or just @post
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post was successfully updated!"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    vote = Vote.find_by(creator: current_user, voteable: @post)  # get the users existing vote (if exists)

    if vote  # if user has already vote on this object, update existing vote
      vote.update(vote: params[:vote], creator: current_user, voteable: @post)
      @message_text = "Vote updated!"
    else  # create new vote if no existing vote
      vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)
      @message_text = "Vote received!"
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:url, :title, :description, category_ids: [])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def require_same_user
    access_denied unless logged_in? && current_user == @post.creator
  end

  def require_same_user_or_admin
    access_denied unless logged_in? && (current_user == @post.creator || logged_in? && current_user.admin?)
  end
end
