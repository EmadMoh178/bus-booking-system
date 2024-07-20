# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :seat

  validates :start_station, :end_station, presence: true
  validate :valid_station_range

  def valid_station_range
    errors.add(:start_station, "must be less than end station") if start_station >= end_station
  end
end