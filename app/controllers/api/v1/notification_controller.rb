class Api::V1::NotificationController < ApplicationController
  before_action :authorize_request

  def update
    notification = @current_user.notification

    if notification.update(notification_params)
      render json: { message: "Notification settings updated successfully", notification: notification }, status: :ok
    else
      render json: { error: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.permit(:app, :email, :sms, :whatsapp)
  end
end
