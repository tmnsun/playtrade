require 'test_helper'

describe Account do
  it 'has valid factory' do
    create(:account).must_be :valid?
  end

  it 'is invalid without email' do
    account = build(:account, email: nil)
    account.must_be :invalid?
    account.errors.must_include(:email)
  end

  it 'is invalid without password' do
    account = build(:account, password: nil)
    account.must_be :invalid?
    account.errors.must_include(:password)
  end

  it 'is invalid with duplicate email' do
    create(:account, email: 'test@email.ru')
    account = build(:account, email: 'test@email.ru')
    account.must_be :invalid?
    account.errors.must_include(:email)
  end

  it 'is invalid without email password' do
    account = build(:account, email_password: nil)
    account.must_be :invalid?
    account.errors.must_include(:email_password)
  end

  it 'can sell if there is no deals' do
    account = create(:account)
    assert account.can_sell?(1)
  end

  it 'can sell if there is disabled deals' do
    account = create(:account)
    create(:deal, type: :p1, account: account, disabled: true)
    create(:deal, type: :p1, account: account, disabled: true)
    assert account.can_sell?(1)
  end

  it 'can sell fi there is enabled deals different type' do
    account = create(:account)
    create(:deal, type: :p2, account: account, disabled: false)
    create(:deal, type: :p3, account: account, disabled: false)
    assert account.can_sell?(1)
  end

  it 'can\'t sell if there is enabled deals' do
    account = create(:account)
    create(:deal, type: :p1, account: account, disabled: false)
    refute account.can_sell?(1)
  end
end
