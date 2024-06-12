require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/api/v1/auth/login' do
    post 'Logs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'User logged in' do
        let(:credentials) { { email: 'user@example.com', password: 'password' } }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:credentials) { { email: 'user@example.com', password: 'wrong_password' } }
        run_test!
      end
    end
  end
end
