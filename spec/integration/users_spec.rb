require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
        },
        required: ['name', 'email', 'password']
      }

      response '201', 'user created' do
        let(:user) { { name: 'John', email: 'john@example.com', password: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'John' } }
        run_test!
      end
    end
  end

  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/users/{id}/update_image' do
    patch 'Update user image' do
      tags 'Users'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          image: { type: :string }
        },
        required: ['image']
      }

      response '200', 'Image updated' do
        let(:id) { user.id }
        let(:user) { { image: 'new_image_url' } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user.id }
        let(:user) { { image: 'new_image_url' } }

        run_test!
      end

      response '422', 'invalid params' do
        let(:id) { user.id }
        let(:user) { { image: nil } }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/delete_image' do
    delete 'Delete user image' do
      tags 'Users'
      security [bearerAuth: []]

      response '200', 'Image deleted' do
        let(:id) { user.id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user.id }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:id) { 'invalid_id' }

        run_test!
      end
    end
  end
end
