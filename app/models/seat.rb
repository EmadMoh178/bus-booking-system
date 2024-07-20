# app/models/seat.rb
class Seat < ApplicationRecord
  has_many :bookings
end
