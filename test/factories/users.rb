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
    factory :rich_user do
      after(:create) do |user|
        user.payments.create(value: 3000)
      end
    end
  end
end
