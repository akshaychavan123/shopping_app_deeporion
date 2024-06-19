require 'twilio-ruby'
class Api::V1::AuthenticationController < ApplicationController

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, username: @user.name }
    else
      render json: { error: 'unauthorized' }
    end
  end

  # def create
  #   @user = User.find_by(phone_number: user_params[:phone_number])

  #   if @user
  #     render json: { error: 'Phone number already exists' }, status: :unprocessable_entity
  #     return
  #   end

  #   @user = User.new(user_params)

  #   if @user.phone_number.present?
  #     @user.password ||= SecureRandom.hex(10)
  #     @user.email ||= nil 
  #   end

  #   if @user.save
  #     send_verification_code(@user)
  #     render json: { user_id: @user.id }, status: :created
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  def create
    @user = User.find_by(phone_number: user_params[:phone_number])

    if @user
      send_verification_code(@user)
      render json: { message: 'Verification code sent', user_id: @user.id }, status: :ok
    else
      @user = User.new(user_params)
      @user.password ||= SecureRandom.hex(10)
      @user.email ||= nil

      if @user.save
        send_verification_code(@user)
        render json: { user_id: @user.id }, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def verify
    @user = User.find_by_id(params[:user_id])
    if @user && @user.phone_verification_code == params[:verification_code]
      @user.update(phone_confirmed: true, phone_verification_code: nil)
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: @user, token: token }, status: :created
    else
      render json: { error: 'Invalid verification code' }, status: :unauthorized
    end
  end
  private

  def login_params
    params.permit(:email, :password)
  end

  def user_params
    params.permit(:phone_number)
  end

  def send_verification_code(user)
    twilio_phone_number = ENV['TWILIO_PHONE_NUMBER']
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    twilio_auth_token = ENV['TWILIO_AUTH_TOKEN']
    
    @client = Twilio::REST::Client.new(account_sid, twilio_auth_token)
    verification_code = rand(100000..999999)
    user.update(phone_verification_code: verification_code)

    begin
      @client.messages.create(
        from: twilio_phone_number,
        to: format_phone_number(user.phone_number),
        body: "Your verification code is #{verification_code}"
      )
    rescue Twilio::REST::RestError => e
      Rails.logger.error "Twilio Error: #{e.message}"
      render json: { error: 'Failed to send verification code' }, status: :unprocessable_entity and return
    end
  end

  def format_phone_number(phone_number)
    phone_number.gsub!(/\D/, '')
    if phone_number.start_with?('0')
      phone_number = phone_number[1..-1]
    end
    "+91#{phone_number}"
  end
end
