class UserForgotPasswordMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def forgot_password(user)
    @user = user
    @token = @user.generate_password_token!
    @reset_url = "http://localhost:3000/reset_password?token=#{@token}&email=#{@user.email}"
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end
