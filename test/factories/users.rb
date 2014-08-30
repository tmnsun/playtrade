# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:login) { |n| "login_#{n}" }
    password 'password'
    password_confirmation 'password'
    factory :admin_user do
      admin true
    end
  end
end
