require "active_storage/engine"

class ApplicationController < ActionController::Base
  include JsonWebToken
  include ActiveStorage::Blob::Analyzable

  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def set_current_user
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        decoded_token = JsonWebToken.decode(token)
        @current_user = User.find(decoded_token[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        @current_user = nil
      end
    end
  end
end
