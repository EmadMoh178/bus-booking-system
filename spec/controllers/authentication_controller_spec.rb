# spec/controllers/authentication_controller_spec.rb

require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

  describe "POST #login" do
    context "with valid credentials" do
      it "returns a token" do
        post :login, params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post :login, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid email or password" })
      end
    end
  end
end
