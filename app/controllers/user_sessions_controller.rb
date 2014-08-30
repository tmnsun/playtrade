# User Sessions
class UserSessionsController < ApplicationController

  before_filter :check_authenticated_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:login], params[:password])
    if @user
      redirect_back_or_to :root, notice: 'Login successful'
    else
      @login_error = true
      render :new
    end
  end

  def destroy
    logout
    redirect_to :root, notice: 'Logged out!'
  end

  protected

  def check_authenticated_user
    redirect_to :root if logged_in?
  end
end
