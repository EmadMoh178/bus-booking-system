# app/models/seat.rb
class Seat < ApplicationRecord
  belongs_to :bus
  has_many :bookings
end