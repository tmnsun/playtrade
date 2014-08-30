# Games admin interface
class Admin::GamesController < AdminController
  inherit_resources

  # def create
  #   create! { admin_games_path }
  # end

  # def update
  #   update! { admin_games_path }
  # end

  protected

  def permitted_params
    params.permit!
  end
end
