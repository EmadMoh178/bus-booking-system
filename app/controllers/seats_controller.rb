# app/controllers/seats_controller.rb
class SeatsController < ApplicationController
  before_action :authorized

  # GET /seats/available?start_station=x&end_station=y
  def available
    start_station = params[:start_station].to_i
    end_station = params[:end_station].to_i

    error_message = validate_station_range(start_station, end_station)
    if error_message
      render json: { error: error_message }, status: :unprocessable_entity and return
    end

    available_seats = Seat.includes(:bookings).all.select do |seat|
      seat.bookings.none? do |booking|
        (booking.start_station < end_station && booking.end_station > start_station)
      end
    end

    render json: { available_seats: available_seats.map(&:number) }, status: :ok
  end

  # POST /seats/book
  def book
    seat_number = params[:seat_number].to_i
    start_station = params[:start_station].to_i
    end_station = params[:end_station].to_i

    if seat_number < 1 || seat_number > 12
      render json: { error: "Seat number must be between 1 and 12" }, status: :unprocessable_entity and return
    end

    error_message = validate_station_range(start_station, end_station)
    if error_message
      render json: { error: error_message }, status: :unprocessable_entity and return
    end

    seat = Seat.find_by(number: seat_number)
    if seat.nil?
      render json: { error: "Seat not found" }, status: :not_found and return
    end

    is_available = seat.bookings.none? do |booking|
      (booking.start_station < end_station && booking.end_station > start_station)
    end

    if is_available
      booking = seat.bookings.create(start_station: start_station, end_station: end_station)
      if booking.persisted?
        render json: { message: "Seat booked successfully", booking: booking }, status: :created
      else
        render json: { error: booking.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render json: { error: "Seat not available for the specified range" }, status: :unprocessable_entity
    end
  end

  private

  def validate_station_range(start_station, end_station)
    if start_station < 1 || start_station > 5 || end_station < 1 || end_station > 5
      "Stations must be between 1 and 5"
    elsif start_station >= end_station
      "Start station must be less than end station"
    end
  end
end
