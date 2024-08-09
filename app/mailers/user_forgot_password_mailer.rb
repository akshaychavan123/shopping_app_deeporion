class UserForgotPasswordMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def forgot_password(user)
    @user = user
    @token = @user.generate_password_token!
    base_url = ENV['BASE_URL'] || 'http://localhost:3000'
    @reset_url = "#{base_url}/reset_password?token=#{@token}&email=#{@user.email}"
    # @reset_url = "http://localhost:3000/reset_password?token=#{@token}&email=#{@user.email}"
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end
