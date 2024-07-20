# app/models/seat.rb
class Seat < ApplicationRecord
  has_many :bookings

  def self.available_seats(start_station, end_station)
    all.select { |seat| seat.available_for_booking?(start_station, end_station) }
  end

  def available_for_booking?(start_station, end_station)
    bookings.none? do |booking|
      (booking.start_station < end_station && booking.end_station > start_station)
    end
  end
end