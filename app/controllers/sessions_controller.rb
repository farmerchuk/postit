class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action :authenticated?, only: [:pin]

  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      if user.two_factor
        session[:authenticated] = true
        user.generate_pin!
        # user.send_pin_to_twilio
        redirect_to pin_path(pin: user.pin)  # sending pin by param instead of twilio
      else
        successful_login(user)
      end
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

  def pin
    @user_pin = params[:pin]
    if request.post?
      user = User.find_by pin: params[:pin]
      if user
        user.update pin: nil
        session[:authenticated] = nil
        successful_login(user)
      else
        flash[:error] = "Incorrect pin! Please try again..."
        redirect_to :back
      end
    end
  end

  private

  def successful_login(user)
    flash[:notice] = "You've successfully logged in!"
    session[:user_id] = user.id
    redirect_to root_path
  end

  def authenticated?
    access_denied unless session[:authenticated] == true
  end
end
