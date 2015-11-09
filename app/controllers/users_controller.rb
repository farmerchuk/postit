class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_user, except: [:new, :show, :create]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "basic"

    if @user.save
      flash[:notice] = "Account successfully created!"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account was successfully updated!"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :time_zone)
  end

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def require_same_user
    access_denied unless logged_in? && current_user == @user
  end
end
