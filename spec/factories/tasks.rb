FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title#{n}"}
    status { :todo }
    association :user
  end
end
