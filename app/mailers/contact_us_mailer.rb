class ContactUsMailer < ApplicationMailer
  default from: 'your-email@example.com'

  def contact_us_resolved(contact_us)
    @contact_us = contact_us
    @user_email = @contact_us.email
    @user_name = @contact_us.name

    mail(to: @user_email, subject: 'Your Contact Us Query has been Resolved')
  end
end
