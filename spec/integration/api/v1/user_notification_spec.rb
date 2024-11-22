require 'swagger_helper'

RSpec.describe 'api/v1/user_notifications', type: :request do
  path '/api/v1/user_notifications' do
    get 'Retrieves all notifications for the current user' do
      tags 'User Notifications'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Notifications retrieved successfully' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   body: { type: :string },
                   read: { type: :boolean },
                   created_at: { type: :string, format: :datetime }
                 },
                 required: ['id', 'title', 'body', 'read', 'created_at']
               }

        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/user_notifications/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Notification ID'

    get 'Retrieves a specific notification' do
      tags 'User Notifications'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Notification retrieved successfully' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:user_notification).id }
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 body: { type: :string },
                 read: { type: :boolean },
                 created_at: { type: :string, format: :datetime }
               },
               required: ['id', 'title', 'body', 'read', 'created_at']

        run_test!
      end

      response '404', 'Notification not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/user_notifications/{id}/mark_as_read' do
    patch 'Marks a notification as read' do
      tags 'User Notifications'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :string, description: 'Notification ID', required: true

      response '200', 'Notification marked as read' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:user_notification).id }

        run_test!
      end

      response '404', 'Notification not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }

        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end
end
