FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.org" }
    username { 'swakhar-dey' }
    password { 'swakhar' }
  end
end
