# spec/models/seat_spec.rb

require 'rails_helper'

RSpec.describe Seat, type: :model do
  describe '#available_for_booking?' do
    let(:seat) { create(:seat) }

    context 'when there are no bookings' do
      it 'returns true' do
        expect(seat.available_for_booking?(1, 5)).to be true
      end
    end

    context 'when there are overlapping bookings' do
      before do
        seat.bookings.create!(start_station: 2, end_station: 4)
      end

      it 'returns false for fully overlapping range' do
        expect(seat.available_for_booking?(1, 5)).to be false
      end

      it 'returns false for partially overlapping range' do
        expect(seat.available_for_booking?(3, 5)).to be false
      end
    end

    context 'when there are non-overlapping bookings' do
      before do
        seat.bookings.create!(start_station: 1, end_station: 2)
        seat.bookings.create!(start_station: 4, end_station: 5)
      end

      it 'returns true' do
        expect(seat.available_for_booking?(2, 4)).to be true
      end
    end
  end
end
