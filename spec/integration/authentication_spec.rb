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
        required: ['email', 'password']
      }

      response '200', 'user logged in' do
        let(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
        let(:credentials) { { email: user.email, password: 'password' } }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'foo', password: 'bar' } }
        run_test!
      end
    end
  end
end