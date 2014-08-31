# Users
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_back_or_to :root, notice: 'User created'
    else
      render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation)
  end
end
