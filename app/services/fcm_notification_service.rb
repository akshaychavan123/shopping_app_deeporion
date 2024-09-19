require 'net/http'
require 'uri'
require 'googleauth'

class FcmNotificationService
  def initialize(coupon)
    @coupon = coupon
    @project_name = ENV['FIREBASE_PROJECT_ID']
  end

  def call
    send_fcm_notifications
  end

  private

  def send_fcm_notifications
    User.includes(:devices, :notification)
        .where.not(devices: { device_token: nil })
        .where(notification: { app: true })
        .each do |user|
      devices = user.devices.where(is_active: true)
      devices.each do |device|
        send_fcm_message(device.device_token)
      end
    end
  end

  def send_fcm_message(device_token)
    message = {
      message: {
        token: device_token,
        notification: {
          title: 'New Coupon Available!',
          body: "New coupon created! #{@coupon.promo_code_name}",
        },
        data: {
          message: "New coupon created! #{@coupon.promo_code_name}"
        }
      }
    }
  
    begin
      api_token = fetch_firebase_access_token
      uri = URI.parse("https://fcm.googleapis.com/v1/projects/#{@project_name}/messages:send")
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request['Authorization'] = "Bearer #{api_token}"
      request.body = message.to_json
  
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
  
      Rails.logger.info "FCM Response: #{response.body}"
    rescue => e
      Rails.logger.error "Failed to send FCM message: #{e.message}"
    end
  end
  
  def fetch_firebase_access_token
    credentials = {
      "type" => "service_account",
      "project_id" => ENV['FIREBASE_PROJECT_ID'],
      "private_key_id" => ENV['FIREBASE_PRIVATE_KEY_ID'],
      "private_key" => ENV['FIREBASE_PRIVATE_KEY'].gsub('\\n', "\n"),
      "client_email" => ENV['FIREBASE_CLIENT_EMAIL'],
      "client_id" => ENV['FIREBASE_CLIENT_ID'],
      "auth_uri" => ENV['FIREBASE_AUTH_URI'],
      "token_uri" => ENV['FIREBASE_TOKEN_URI'],
      "auth_provider_x509_cert_url" => ENV['FIREBASE_AUTH_PROVIDER_CERT_URL'],
      "client_x509_cert_url" => ENV['FIREBASE_CLIENT_CERT_URL']
    }
  
    scope = ['https://www.googleapis.com/auth/firebase.messaging']
  
    authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(credentials.to_json),
      scope: scope
    )
    authorization.fetch_access_token!
    authorization.access_token
  end
end
