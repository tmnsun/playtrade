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
