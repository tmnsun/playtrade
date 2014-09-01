class IndexController < ApplicationController
  def index
    account_ids = Deal.where(disabled: false).pluck(:account_id)
    @accounts = Account.where(:_id.in => account_ids)
  end
end
