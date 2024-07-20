# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :seat

  validates :start_station, :end_station, presence: true
  validate :valid_station_range, :stations_within_range

  def valid_station_range
    if start_station >= end_station
      errors.add(:base, "Start station must be less than end station")
    end
  end

  def stations_within_range
    if start_station < 1 || start_station > 5
      errors.add(:start_station, "must be between 1 and 5")
    end
    if end_station < 1 || end_station > 5
      errors.add(:end_station, "must be between 1 and 5")
    end
  end
end
