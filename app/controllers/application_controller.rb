class ApplicationController < ActionController::API
  before_action :authorized

  SECRET_KEY = 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8g9h0i1j2k3l4m5n6o7p8q9r0s1t2u3v4w5x6y7z8'

  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def auth_header
    request.headers['Authorization']
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def token_blacklisted?(token)
    Blacklist.exists?(token: token)
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      if token_blacklisted?(token)
        nil
      else
        begin
          JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
        rescue JWT::DecodeError, JWT::ExpiredSignature
          nil
        end
      end
    end
  end
end
