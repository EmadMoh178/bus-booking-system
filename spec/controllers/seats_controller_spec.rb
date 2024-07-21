# spec/controllers/seats_controller_spec.rb

require 'rails_helper'

RSpec.describe SeatsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, ApplicationController::SECRET_KEY) }
  let(:valid_headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET #available' do
    before { request.headers.merge!(valid_headers) }

    context 'when there are available seats' do
      it 'returns a list of available seats' do
        get :available, params: { start_station: 'Cairo', end_station: 'Giza' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the city names are invalid' do
      it 'returns an error message' do
        get :available, params: { start_station: 'InvalidCity', end_station: 'Giza' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #book' do
    before { request.headers.merge!(valid_headers) }

    context 'when booking a seat successfully' do
      let(:seat) { create(:seat) }

      it 'creates a booking' do
        post :book, params: { seat_number: seat.number, start_station: 'Cairo', end_station: 'Giza' }
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the seat number is invalid' do
      it 'returns an error message' do
        post :book, params: { seat_number: 13, start_station: 'Cairo', end_station: 'Giza' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
