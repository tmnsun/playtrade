# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deal do
    type { rand(1..3) }
    price { rand(100..1000) }
    account { association(:account) }
    user { association(:user) }

    factory(:p1_deal) do
      type 1
    end

    factory(:p2_deal) do
      type 2
    end

    factory(:p3_deal) do
      type 3
    end
  end
end
