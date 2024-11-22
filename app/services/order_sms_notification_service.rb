class OrderSmsNotificationService
  def initialize(order, full_phone_number)
    @order = order
    @full_phone_number = full_phone_number
    @twilio_client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @twilio_phone_number = ENV['TWILIO_PHONE_NUMBER']
  end

  def call
    send_sms_notification
  end

  private

  def send_sms_notification
    message = "Hello #{@order.user.name}, your order ##{@order.id} has been placed successfully! Thank you for shopping with us."

    begin
      @twilio_client.messages.create(
        from: @twilio_phone_number,
        to: format_full_phone_number(@full_phone_number),
        body: message
      )
    rescue Twilio::REST::RestError => e
      Rails.logger.error "Twilio Error: #{e.message}"
    end
  end

  def format_full_phone_number(full_phone_number)
    "+#{full_phone_number.gsub(/\D/, '')}"
  end
end
