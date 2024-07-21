# spec/models/booking_spec.rb

require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'validations' do
    it 'is invalid if start_station is not less than end_station' do
      booking = Booking.new(start_station: 3, end_station: 2)
      expect(booking).not_to be_valid
      expect(booking.errors[:base]).to include('Start station must be less than end station')
    end

    it 'is invalid if start_station is out of range' do
      booking = Booking.new(start_station: 6, end_station: 7)
      expect(booking).not_to be_valid
      expect(booking.errors[:start_station]).to include('must be between 1 and 5')
    end

    it 'is invalid if end_station is out of range' do
      booking = Booking.new(start_station: 2, end_station: 6)
      expect(booking).not_to be_valid
      expect(booking.errors[:end_station]).to include('must be between 1 and 5')
    end
  end
end
