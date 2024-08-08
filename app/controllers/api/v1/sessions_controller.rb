require 'httparty'                                                             
require 'json'
class Api::V1::SessionsController < ApplicationController
  include HTTParty

  def google_auth
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params["id_token"]}"                  
    response = HTTParty.get(url)                   
    @user = User.create_user_for_google(response.parsed_response)      

    if @user.new_record?
      if @user.save
        payload = { user_id: @user.id }
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
        render json: { jwt: token, user: @user }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      payload = { user_id: @user.id }
      token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
      render json: { jwt: token, user: @user }, status: :ok
    end
  end
end