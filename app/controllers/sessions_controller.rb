class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  
  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      flash[:notice] = "You've successfully logged in!"
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "Incorrect 'username' or 'password'!"
      redirect_to login_path
    end
  end

  def destroy
    flash[:notice] = "You have successfully logged out!"
    session[:user_id] = nil
    redirect_to login_path
  end
end
