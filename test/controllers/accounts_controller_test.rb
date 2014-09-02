require 'test_helper'

describe AccountsController do
  before do
    @account = create(:account)
    @deal = create(:p3_deal, account: @account)
  end

  it 'should get 302 with unauthorized user' do
    get :buy, id: @account.id, type: @deal.type_cd
    assert_response 302
  end

  it 'should get buy with active deals' do
    login_user(create(:user))
    get :buy, id: @account.id, type: @deal.type_cd
    assert_response :success
  end
end
