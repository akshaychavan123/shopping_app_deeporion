class Api::V1::NotificationController < ApplicationController
  before_action :authorize_request

  def show_notification
    notification = @current_user.notification

    if notification
      render json: { notification: notification }, status: :ok
    else
      render json: { error: [] }, status: :ok
    end
  end

  def update
    notification = @current_user.notification

    if notification.update(notification_params)
      send_notifications(notification)
      render json: { message: "Notification settings updated successfully", notification: notification }, status: :ok
    else
      render json: { error: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.permit(:app, :email, :sms, :whatsapp)
  end

  def notification_params
    params.permit(:app, :email, :sms, :whatsapp)
  end

  def send_notifications(notification)
    if notification.app && @current_user.devices.exists?
      FcmNotificationSubscribeService.new(@current_user).call
    end

    if notification.email && @current_user.email.present?
      NotificationMailer.with(user: @current_user).send_notification_email.deliver_now
    end
    # SMS Notification paused
    # if notification.sms && @current_user.full_phone_number.present?
    #   SmsSubscribeService.new(@current_user.full_phone_number, "Thank you for subscribing us.").send_sms
    # end
  end
end
