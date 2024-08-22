class Api::V1::PasswordsController < ApplicationController
  def forgot
    if params[:email].blank?
      return render json: { error: 'Email not present' }
    end

    @user = User.find_by(email: params[:email])
    if @user.present?
      UserForgotPasswordMailer.forgot_password(@user).deliver_now
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s

    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end

    payload = User.decode_password_token(token)
    puts "----------------------------------------------->>>>>   payload - #{payload}"
    @user = User.find_by(id: payload[:user_id]) if payload

    if @user.present?
      if @user.update(password_params)
        render json: { status: 'ok' }, status: :ok
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end