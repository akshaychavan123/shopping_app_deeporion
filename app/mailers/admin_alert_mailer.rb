class AdminAlertMailer < ApplicationMailer
  def unauthorized_attempt_alert
    @attempted_email = params[:email]
    @admin_email = params[:admin_email]
    mail(
      to: @admin_email,
      subject: 'Unauthorized Password Reset Attempts Detected'
    )
  end
end