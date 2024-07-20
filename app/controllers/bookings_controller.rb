class BookingsController < ApplicationController
  before_action :authorized

  def available_seats
    start_city_id = params[:start_city_id].to_i
    end_city_id = params[:end_city_id].to_i

    if start_city_id < 1 || start_city_id > 5 || end_city_id < 1 || end_city_id > 5 || start_city_id >= end_city_id
      render json: { error: "Invalid city IDs" }, status: :bad_request
      return
    end

    trip = Trip.find_by(start_city_id: start_city_id, end_city_id: end_city_id)
    if trip.nil?
      render json: { error: "Trip not found" }, status: :not_found
      return
    end

    bus = trip.bus
    if bus.nil?
      render json: { error: "Bus not found for this trip" }, status: :not_found
      return
    end

    available_seats = bus.seats.select do |seat|
      !seat.bookings.any? do |booking|
        intersects?(booking.start_city_id, booking.end_city_id, start_city_id, end_city_id)
      end
    end

    render json: { available_seats: available_seats.map(&:seat_number) }
  end

  def book_seat
    seat_number = params[:seat_number].to_i
    start_city_id = params[:start_city_id].to_i
    end_city_id = params[:end_city_id].to_i

    if seat_number < 1 || seat_number > 12 || start_city_id < 1 || start_city_id > 5 || end_city_id < 1 || end_city_id > 5 || start_city_id >= end_city_id
      render json: { error: "Invalid seat or city IDs" }, status: :bad_request
      return
    end

    trip = Trip.find_by(start_city_id: start_city_id, end_city_id: end_city_id)
    if trip.nil?
      render json: { error: "Trip not found" }, status: :not_found
      return
    end

    bus = trip.bus
    seat = bus.seats.find_by(seat_number: seat_number)
    if seat.nil?
      render json: { error: "Seat not found" }, status: :not_found
      return
    end

    if seat.bookings.any? { |booking| intersects?(booking.start_city_id, booking.end_city_id, start_city_id, end_city_id) }
      render json: { error: "Seat is not available" }, status: :bad_request
      return
    end

    Booking.create(user: current_user, seat: seat, start_city_id: start_city_id, end_city_id: end_city_id)
    render json: { message: "Seat booked successfully" }
  end

  private

  def intersects?(a_start, a_end, b_start, b_end)
    (a_start < b_end && b_start < a_end)
  end
end