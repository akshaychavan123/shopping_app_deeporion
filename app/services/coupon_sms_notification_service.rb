class CouponSmsNotificationService
  def initialize(coupon)
    @coupon = coupon
    @twilio_client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @twilio_phone_number = ENV['TWILIO_PHONE_NUMBER']
  end

  def call
    send_sms_notifications
  end

  private

  def send_sms_notifications
    User.includes(:notification).where.not(full_phone_number: nil).find_each do |user|
      if user.notification&.sms
        send_sms(user)
      end
    end
  end

  def send_sms(user)
    message = "Hello #{user.name}, new coupon available: #{@coupon.promo_code_name}! Check out the discount now!"
    
    begin
      @twilio_client.messages.create(
        from: @twilio_phone_number,
        to: format_full_phone_number(user.full_phone_number),
        body: message
      )
    rescue Twilio::REST::RestError => e
      Rails.logger.error "Twilio Error: #{e.message}"
    end
  end

  def format_full_phone_number(full_phone_number)
    full_phone_number.gsub(/\D/, '')
    "+#{full_phone_number}"
  end
end
