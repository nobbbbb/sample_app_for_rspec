FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "foobar#{n}@example.com"}
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
