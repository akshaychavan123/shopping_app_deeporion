class Api::V1::UserNotificationsController < ApplicationController
  before_action :authorize_request
  before_action :set_notification, only: [:show, :mark_as_read]
  
  def index
    @notifications = @current_user.user_notifications.order(created_at: :desc)
    render json: @notifications, status: :ok
  end

  def show
    render json: @notification, status: :ok
  end

  def mark_as_read
    if @notification.update(read: true)
      render json: { message: 'Notification marked as read' }, status: :ok
    else
      render json: { error: 'Unable to mark notification as read' }, status: :unprocessable_entity
    end
  end

  private

  def set_notification
    @notification = @current_user.user_notifications.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Notification not found' }, status: :not_found
  end
end
