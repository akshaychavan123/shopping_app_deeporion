require 'twilio-ruby'

class SmsSubscribeService
  def initialize(full_phone_number, message)
    @full_phone_number = full_phone_number
    @message = message
    @twilio_client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @twilio_phone_number = ENV['TWILIO_PHONE_NUMBER']
  end

  def send_sms
    @twilio_client.messages.create(
      from: @twilio_phone_number,
      to: format_phone_number(@full_phone_number),
      body: @message
    )
  rescue Twilio::REST::RestError => e
    Rails.logger.error "Twilio Error: #{e.message}"
  rescue StandardError => e
    Rails.logger.error "Failed to send SMS: #{e.message}"
  end

  private

  def format_phone_number(full_phone_number)
    full_phone_number.gsub(/\D/, '').prepend('+')
  end
end
