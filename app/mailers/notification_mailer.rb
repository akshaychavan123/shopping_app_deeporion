class NotificationMailer < ApplicationMailer
  def send_notification_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Notification Update')
  end
end
