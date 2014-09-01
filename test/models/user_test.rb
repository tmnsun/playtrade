require 'test_helper'

describe User do
  it 'has a valid factory' do
    create(:user).must_be :valid?
  end

  it 'is invalid without a login' do
    user = build(:user, login: nil)
    user.must_be :invalid?
  end

  it 'is invalid with minus character in login' do
    user = build(:user, login: 'a--b')
    user.must_be :invalid?
    user.errors.must_include(:login)
  end

  it 'is invalid with space inside login' do
    user = build(:user, login: 'ab cd')
    user.must_be :invalid?
    user.errors.must_include(:login)
  end

  it 'is invalid with less than 3 characters login' do
    user = build(:user, login: 'ab')
    user.must_be :invalid?
    user.errors.must_include(:login)
  end

  it 'is invalid with more than 30 characters login' do
    user = build(:user, login: Faker::Number.number(31))
    user.must_be :invalid?
    user.errors.must_include(:login)
  end

  it 'is valid with 3 characters length login' do
    user = build(:user, login: Faker::Number.number(3))
    user.must_be :valid?
  end

  it 'is valid with 30 characters length login' do
    user = build(:user, login: Faker::Number.number(30))
    user.must_be :valid?
  end

  it 'is valid with underscore login' do
    user = build(:user, login: '___')
    user.must_be :valid?
  end

  it 'is valid with numeric login' do
    user = build(:user, login: 123)
    user.must_be :valid?
  end

  it 'is invalid with duplicate login' do
    create(:user, login: 'testlogin')
    user = build(:user, login: 'testlogin')
    user.must_be :invalid?
    user.errors.must_include(:login)
  end
end

describe 'user balance and payments' do
  before do
    @user = create(:user)
  end

  it 'should have zero balance' do
    assert_equal 0, @user.balance
  end

  it 'should have balance = 100' do
    @user.payments.create(value: 15)
    @user.payments.create(value: 85)
    assert_equal 100, @user.balance
  end

  it 'cant buy account without necessary balance amount' do
    account = create(:account)
    deal = create(:deal, account: account, type: 3, price: 1000)
    deals_count = @user.deals.count
    assert_raises InsufficientFunds do
      @user.deals << deal
    end
    assert_equal deals_count, @user.reload.deals.count
  end

  it 'should buy account' do
    account = create(:account)
    deal = create(:deal, account: account, type: 3, price: 1000)
    @user.payments.create(value: 700)
    @user.payments.create(value: 315)
    @user.deals << deal
    assert_equal @user.balance, 15
  end

  it 'cant remove deal after buy' do
    account = create(:account)
    deal = create(:deal, account: account, type: 3, price: 1000)
    @user.payments.create(value: 1000)
    @user.deals << deal
    assert_raises CantRemoveDealFromUser do
      @user.deals.delete(deal)
    end
  end
end
