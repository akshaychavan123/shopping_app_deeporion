require 'swagger_helper'

RSpec.describe 'api/v1/notification/{id}', type: :request do
  path '/api/v1/notification/show_notification' do
    get 'Retrieves Notification Settings' do
      tags 'Notifications'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Notification settings retrieved successfully' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        schema type: :object,
               properties: {
                 notification: {
                   type: :object,
                   properties: {
                     app: { type: :boolean },
                     email: { type: :boolean },
                     sms: { type: :boolean },
                     whatsapp: { type: :boolean }
                   }
                 }
               }

        run_test!
      end

      response '404', 'Notification settings not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/notification/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Notification ID'
    patch 'Updates Notification Settings' do
      tags 'Notifications'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :notification, in: :body, schema: {
        type: :object,
        properties: {
          app: { type: :boolean },
          email: { type: :boolean },
          sms: { type: :boolean },
          whatsapp: { type: :boolean }
        },
        required: ['app', 'email', 'sms', 'whatsapp']
      }

      response '200', 'Notification settings updated successfully' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:notification) { { app: true, email: false, sms: true, whatsapp: false } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:notification) { { app: true, email: false } } 
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:notification) { { app: true, email: false, sms: true, whatsapp: false } }
        run_test!
      end
    end
  end
end
