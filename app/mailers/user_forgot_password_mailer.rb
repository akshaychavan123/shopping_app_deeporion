class UserForgotPasswordMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def forgot_password(user)
    @user = user
    @token = @user.generate_password_token!
    @reset_url = "http://localhost:6006/?path=/story/examples-form--new-password&token=#{@token}&email=#{@user.email}"
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end
