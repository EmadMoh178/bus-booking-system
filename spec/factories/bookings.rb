# spec/factories/bookings.rb

FactoryBot.define do
  factory :booking do
    start_station { Faker::Number.between(from: 1, to: 5) }
    end_station { Faker::Number.between(from: 1, to: 5) }
    association :seat

    # Ensure start_station is less than end_station for valid bookings
    after(:build) do |booking|
      if booking.start_station >= booking.end_station
        booking.end_station = booking.start_station + 1
      end
    end
  end
end
