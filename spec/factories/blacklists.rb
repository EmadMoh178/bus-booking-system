# spec/factories/blacklists.rb

FactoryBot.define do
  factory :blacklist do
    token { SecureRandom.hex(20) }
  end
end
