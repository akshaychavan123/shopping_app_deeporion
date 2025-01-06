class Api::V1::PasswordsController < ApplicationController
  RESET_LINK_INTERVAL = 30.seconds # Define interval time (30 seconds)

  def forgot
    if params[:email].blank? || params[:type].blank?
      return render json: { error: 'Email and type are required.' }, status: :bad_request
    end

    if params[:type].casecmp?('admin')
      return handle_admin_reset_request(params[:email])
    else
      return handle_user_reset_request(params[:email])
    end
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
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :ok
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

  def update_reset_timestamp(user)
    user.update!(password_reset_requested_at: Time.current)
  end

  # Logic for handling admin password reset
  def handle_admin_reset_request(email)
    admin_emails = User.where(type: 'Admin').pluck(:email) # Fetch all admin emails
    admin_email_alert_limit = 2

    unless admin_emails.include?(email)
      increment_failed_admin_attempts(email)

      if failed_admin_attempts > admin_email_alert_limit
        send_alert_to_admin(email)
      end

      return render json: { error: 'Unauthorized email for admin reset.' }, status: :unauthorized
    end

    @user = User.find_by(email: email, type: 'Admin')

    if password_reset_recently_requested?(@user)
      return render json: { error: 'You can only request a reset link once every 30 seconds.' }, status: :too_many_requests
    end

    send_reset_email(@user)
    update_reset_timestamp(@user)

    render json: { status: 'A reset link has been sent to your email address.' }, status: :ok
  end

  # Logic for handling user password reset
  def handle_user_reset_request(email)
    @user = User.find_by(email: email)

    unless @user
      return render json: { error: 'Email address not found. Please check and try again.' }, status: :ok
    end

    if password_reset_recently_requested?(@user)
      return render json: { error: 'You can only request a reset link once every 30 seconds.' }, status: :too_many_requests
    end

    send_reset_email(@user)
    update_reset_timestamp(@user)

    render json: { status: 'A reset link has been sent to your email address.' }, status: :ok
  end

  # Helper method to track failed attempts for admin email
  def increment_failed_admin_attempts(email)
    # Read the current number of failed attempts from cache
    current_attempts = failed_admin_attempts

    new_attempts = current_attempts + 1

    Rails.cache.write("failed_admin_login_attempts", new_attempts, expires_in: 1.hour)
    Rails.logger.info "failed attempt to reset admin with email #{email}: #{new_attempts}"
  end

  def failed_admin_attempts
    Rails.cache.read("failed_admin_login_attempts").to_i
  end

  # Alert the admin in case of too many unauthorized attempts
  def send_alert_to_admin(email)
    Rails.logger.debug"==============SENDING ALERT TO ADMIN FOR FAILED ATTEMPTS TO LOGIN with email: #{email}=================="
    admin_email = User.find_by(type: 'Admin').email # Send to the primary admin email
    AdminAlertMailer.with(email: email, admin_email: admin_email).unauthorized_attempt_alert.deliver_now
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end