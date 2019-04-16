FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.org" }
    firstname { 'Swakhar' }
    lastname { 'Dey' }
    username { 'swakhar-dey' }
    password { 'swakhar' }
  end
end
