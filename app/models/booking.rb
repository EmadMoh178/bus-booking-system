# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :seat
  belongs_to :start_city, class_name: 'City'
  belongs_to :end_city, class_name: 'City'
end