class Device < ApplicationRecord
  require 'fcm'
  require 'json'

  belongs_to :user
  # belongs_to :push_notificable, polymorphic: true
  validates :device_token, presence: true, uniqueness: { scope: :user_id }


  # def self.manage_push_notification(object)
  #   Device.create(user_id: object.user.id, push_notificable: object)
  # end

  def self.send_push_notification(type, title, body, object, user)
    registration_token = user.device_token&.registration_token
    device_type = user.device_token&.device_type

    if registration_token.present? && device_type.present?
      message = {
        message: {
          token: registration_token,
          data: {
            type: type,
            id: object.id.to_s,
            account_id: user&.id.to_s
          }
        }
      }

      if device_type == 'ios'
        message[:message][:apns] = {
          payload: {
            aps: {
              alert: {
                title: title,
                body: body
              },
              sound: 'default'
            }
          }message
        }
      elsif device_type == 'android'
        message[:message][:android] = {
          notification: {
            title: title,
            body: body,
            sound: 'default'
          }
        }
      end

      api_token = get_access_token
      uri = URI.parse("https://fcm.googleapis.com/v1/projects/#{@project_name}/messages:send")
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request['Authorization'] = "Bearer #{api_token}"
      request.body = message.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      puts response
      response
    else
      puts 'Registration token or device type is missing.'
      nil
    end
  end

  private

  def self.get_access_token
    key_file_path = Rails.root.join('app/keys', 'fcm-key.json')
    key_file = File.read(key_file_path)
    @project_name = JSON.parse(key_file)['project_id']
    scopes = ['https://www.googleapis.com/auth/firebase.messaging']

    # authorization = Google::Auth::ServiceAccountCredentials.make_creds(
    #   json_key_io: StringIO.new(key_file),
    #   scope: scopes
    # )

    authorization.fetch_access_token!
    authorization.access_token
  end
end
