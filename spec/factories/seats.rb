# spec/factories/seats.rb

FactoryBot.define do
  factory :seat do
    number { Faker::Number.between(from: 1, to: 12) }
  end
end
