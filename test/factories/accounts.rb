require 'faker'

FactoryGirl.define do
  factory :account do
    email_password 'email_password'
    password 'password'
    email { Faker::Internet.email }
    after(:create) { |account| account.games = [create(:game)] }
  end
end
