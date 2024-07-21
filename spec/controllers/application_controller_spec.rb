# spec/controllers/application_controller_spec.rb

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { message: "Welcome!" }
    end
  end

  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, ApplicationController::SECRET_KEY) }
  let(:expired_token) { JWT.encode({ user_id: user.id, exp: 1.hour.ago.to_i }, ApplicationController::SECRET_KEY) }

  describe "Authorization" do
    it "renders the index if authorized" do
      request.headers['Authorization'] = "Bearer #{token}"
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({ message: "Welcome!" }.to_json)
    end

    it "renders unauthorized if no token is provided" do
      get :index
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ message: "Please log in" }.to_json)
    end

    it "renders unauthorized if token is expired" do
      request.headers['Authorization'] = "Bearer #{expired_token}"
      get :index
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ message: "Please log in" }.to_json)
    end

    it "renders unauthorized if token is blacklisted" do
      Blacklist.create(token: token)
      request.headers['Authorization'] = "Bearer #{token}"
      get :index
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ message: "Please log in" }.to_json)
    end
  end
end
