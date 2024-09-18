require 'net/http'
require 'uri'
require 'googleauth'

class FcmNotificationService
  def initialize(coupon)
    @coupon = coupon
    @project_name = 'pinklay-firebase-console'
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
    key_file_path = Rails.root.join('app/keys/fcm_key.json')
    key_file = File.read(key_file_path)
    @project_name = JSON.parse(key_file)['project_id']
    scope = ['https://www.googleapis.com/auth/firebase.messaging']
    authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(key_file),
      scope: scope
      )
      authorization.fetch_access_token!
      authorization.access_token
  end
end
