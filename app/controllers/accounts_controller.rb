class AccountsController < ApplicationController
  before_filter :find_account, only: [:buy, :checkout]
  before_filter :find_last_deal, only: [:buy, :checkout]

  def buy
  end

  def checkout
  end

  protected

  def find_account
    @account = Account.find(params[:id])
  end

  def find_last_deal
    @deal = @account.last_deal(params[:type])
  end
end
