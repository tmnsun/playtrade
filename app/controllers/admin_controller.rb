# Admin class
class AdminController < ApplicationController
  before_filter :require_login
  before_filter :admin_check

  protected

  def admin_check
    redirect_to root_path unless current_user.admin?
  end
end
