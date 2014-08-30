# Accounts admin interface
class Admin::AccountsController < AdminController
  inherit_resources

  custom_actions resource: [:add_game, :add_deal, :remove_deal]

  def add_game
    add_game! do
      @game = Game.find(params[:game_id])
      @account.games << @game
      return redirect_to admin_account_path(@account)
    end
  end

  def add_deal
    add_deal! do
      @account.deals.create(params.permit(:price, :type))
      return redirect_to admin_account_path(@account)
    end
  end

  def remove_deal
    remove_deal! do
      @deal = Deal.find(params[:deal_id])
      @deal.destroy
      return redirect_to admin_account_path(@account)
    end
  end

  protected

  def permitted_params
    params.permit!
  end
end
