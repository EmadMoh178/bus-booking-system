# app/controllers/authentication_controller.rb

class AuthenticationController < ApplicationController
  skip_before_action :authorized, only: [:login]

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
