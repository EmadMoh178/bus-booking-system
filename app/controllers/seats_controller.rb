# app/controllers/seats_controller.rb
class SeatsController < ApplicationController
  include CityMapping

  before_action :authorized

  # GET /seats/available
  def available
    start_station, end_station = validate_station_params
    return if performed?

    available_seats = Seat.available_seats(start_station, end_station)
    render json: { available_seats: available_seats.map(&:number) }, status: :ok
  end

  # POST /seats/book
  def book
    seat_number = params[:seat_number].to_i
    start_station, end_station = validate_station_params
    return if performed?

    if seat_number < 1 || seat_number > 12
      render json: { error: "Seat number must be between 1 and 12" }, status: :unprocessable_entity and return
    end

    seat = Seat.find_by(number: seat_number)
    if seat.nil?
      render json: { error: "Seat not found" }, status: :not_found and return
    end

    is_available = seat.available_for_booking?(start_station, end_station)

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

  def validate_station_params
    start_station_name = params[:start_station]
    end_station_name = params[:end_station]

    unless CityMapping.valid_city?(start_station_name) && CityMapping.valid_city?(end_station_name)
      render json: { error: "Invalid city names. Available options are: #{CityMapping::CITIES.keys.join(', ')}" }, status: :unprocessable_entity and return
    end

    start_station = CityMapping.city_to_number(start_station_name)
    end_station = CityMapping.city_to_number(end_station_name)

    error_message = validate_station_range(start_station, end_station)
    if error_message
      render json: { error: error_message }, status: :unprocessable_entity and return
    end

    [start_station, end_station]
  end

  def validate_station_range(start_station, end_station)
    if start_station < 1 || start_station > 5 || end_station < 1 || end_station > 5
      "Stations must be between 1 and 5"
    elsif start_station >= end_station
      "Start station must be less than end station"
    end
  end
end
