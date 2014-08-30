FactoryGirl.define do
  factory :game do
    sequence(:title) { |n| "Game #{n}" }
  end
end
