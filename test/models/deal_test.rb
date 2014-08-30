require 'test_helper'

describe Deal do

  it 'has valid factory' do
    create(:deal).must_be :valid?
  end

  it 'is not valid without price' do
    build(:deal, price: nil).must_be :invalid?
  end

  it 'is not valid with string price' do
    build(:deal, price: 'test').must_be :invalid?
  end

  it 'is not valid without an account' do
    build(:deal, account: nil).must_be :invalid?
  end

  # it 'is not valid without a user' do
  #   build(:deal, user: nil).must_be :invalid?
  # end

  it 'must be enabled by default' do
    refute(build(:deal).disabled)
  end

  it 'has two opposite values for enable and disable' do
    deal = build(:deal)
    refute deal.enabled? == deal.disabled?
    deal.disabled = true
    refute deal.enabled? == deal.disabled?
  end

  it 'cant be disabled without user' do
    build(:deal, user: nil, disabled: true).must_be :invalid?
  end

  it 'can be destroyed without user' do
    deal = create(:deal, user: nil)
    deal.destroy
    assert deal.destroyed?
  end

  it 'can\'t be destroyed with user' do
    deal = create(:deal)
    deal.destroy
    refute deal.destroyed?
  end

  context 'disabled? method' do
    it 'must return false on if enabled' do
      refute(build(:deal).disabled?)
    end

    it 'must return true if disabled' do
      assert(build(:deal, disabled: true).disabled?)
    end
  end

  it 'is not valid if there is enabled deal with same account and type' do
    account = create(:account)
    create(:p2_deal, user: create(:user), account: account, created_at: 5.minutes.ago)
    second_deal = build(:p2_deal, user: create(:user), account: account)
    second_deal.must_be :invalid?
  end

  it 'is not valid if there is previous deal with same user and type' do
    user = create(:user)
    account = create(:account)

    # first deal
    create(:p2_deal, user: user, account: account, disabled: true, created_at: 5.minutes.ago)

    second_deal = build(:p2_deal, user: user, account: account)
    second_deal.must_be :invalid?
  end
end

describe 'deals list' do
  before :each do
    account = create(:account)

    @first_deal = create(:p3_deal, account: account, disabled: true, created_at: 10.minutes.ago)
    @second_deal = create(:p3_deal, account: account, disabled: true, created_at: 5.minutes.ago)
    @third_deal = create(:p3_deal, account: account)
  end

  context 'next_deal' do
    it 'must return nil for last deal' do
      assert_nil(@third_deal.next_deal)
    end

    it 'must return second_deal for first deal' do
      assert_equal(@second_deal, @first_deal.next_deal)
    end

    it 'must return third_deal for second deal' do
      assert_equal(@third_deal, @second_deal.next_deal)
    end
  end

  context 'prev_deal' do
    it 'must return nil for first deal' do
      assert_nil(@first_deal.prev_deal)
    end

    it 'must return first_deal for second_deal' do
      assert_equal(@first_deal, @second_deal.prev_deal)
    end

    it 'must return second deal for third deal' do
      assert_equal(@second_deal, @third_deal.prev_deal)
    end
  end
end
