require "test_helper"

describe Admin::AccountsController do
  before do
    user = create(:admin_user)
    login_user(user)
  end

  it 'must render index template with all accounts' do
    get :index
    assert_template :index
    assigns(:accounts).must_be_kind_of(Mongoid::Criteria)
    assert_equal assigns(:accounts).count, Account.count
  end

  it 'must update account and redirect to account show' do
    account = create(:account, password: 'old_password')
    post :update, id: account.id, account: attributes_for(:account, password: 'new_password')
    account.reload
    assert_equal account.password, 'new_password'
    assert_redirected_to admin_account_path(account)
  end

  it 'must create account and redirect to account show' do
    accounts_count = Account.count
    post :create, account: attributes_for(:account)
    assert_equal(accounts_count + 1, Account.count)
    assert_redirected_to admin_account_path(Account.last)
  end

  it 'must render new form' do
    post :create, account: attributes_for(:account, email: nil)
    assert_template :new
  end

  it 'must add game to account' do
    account = create(:account)
    game = create(:game)
    post :add_game, id: account.id, game_id: game.id
    assert_redirected_to admin_account_path(account)
    account.reload
    assert_equal game, account.games.last
  end

  it 'must add deal to account' do
    account = create(:account)
    deals_count = account.deals.count
    post :add_deal, id: account.id, type: 'p1', price: 650
    assert_equal(deals_count + 1, account.reload.deals.count)
    assert_redirected_to admin_account_path(account)
  end

  it 'should not add deal if there is enabled deal of same type' do
    account = create(:account)
    create(:deal, type: 'p3', account: account)
    deals_count = account.deals.count
    post :add_deal, id: account.id, type: 'p3', price: 400
    assert_equal(deals_count, account.reload.deals.count)
    assert_redirected_to admin_account_path(account)
  end

  it 'should add deal if there is enabled deal of same type for different account' do
    account = create(:account)
    account_2 = create(:account)
    create(:deal, type: 'p3', account: account)
    post :add_deal, id: account_2.id, type: 'p3', price: 400
  end

  it 'should add deal if there is disabled deal of same type' do
    account = create(:account)
    deal = create(:deal, type: 'p2', account: account)
    deal.disabled = true
    deal.save
    post :add_deal, id: account.id, type: 'p3', price: 400
  end

  it 'should remove deal if it has no user' do
    account = create(:account)
    deal = create(:deal, type: :p2, account: account, user: nil)
    deals_count = account.deals.count
    post :remove_deal, id: account.id, deal_id: deal.id
    assert_equal(deals_count - 1, account.reload.deals.count)
  end

  it 'should not remove deal with user' do
    account = create(:account)
    deal = create(:deal, type: :p2, account: account)
    deals_count = account.deals.count
    post :remove_deal, id: account.id, deal_id: deal.id
    assert_equal(deals_count, account.reload.deals.count)
  end
end
