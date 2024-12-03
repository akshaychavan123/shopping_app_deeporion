class Api::V1::PasswordsController < ApplicationController
  RESET_LINK_INTERVAL = 30.seconds # Define interval time (30 seconds)

  def forgot
    # Return early if the email parameter is missing
    return render json: { error: 'Email not present' }, status: :bad_request if params[:email].blank?

    @user = User.find_by(email: params[:email])
    # Return if the user is not found
    return render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found unless @user

    # Return early if the user requested a reset link too recently
    if password_reset_recently_requested?(@user)
      return render json: { error: 'You can only request a reset link once every 30 seconds.' }, status: :too_many_requests
    end

    # Send the reset email and update the timestamp
    send_reset_email(@user)
    update_reset_timestamp(@user)

    render json: { status: 'Link sent to your email' }, status: :ok
  end

  def reset
    token = params[:token].to_s

    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end

    payload = User.decode_password_token(token)
    @user = User.find_by(id: payload[:user_id]) if payload

    if @user.present?
      if @user.update(password_params)
        render json: { status: 'Password changed successfully' }, status: :ok
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  private

  # Check if the user has requested a reset link recently
  def password_reset_recently_requested?(user)
    user.password_reset_requested_at && user.password_reset_requested_at > RESET_LINK_INTERVAL.ago
  end

  # Send the password reset email
  def send_reset_email(user)
    UserForgotPasswordMailer.forgot_password(user).deliver_now
  end

  # Update the password reset timestamp
  def update_reset_timestamp(user)
    user.update!(password_reset_requested_at: Time.current)
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end