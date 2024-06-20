require 'swagger_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do

  path '/api/v1/auth/google_oauth2' do
    post('Google OAuth2 Authentication') do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :auth_token, in: :header, type: :string, description: 'OAuth token'

      response '200', 'successful' do
        schema type: :object,
          properties: {
            jwt: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                email: { type: :string }
                # Add other user properties as needed
              },
              required: [ 'id', 'name', 'email' ]
            }
          },
          required: [ 'jwt', 'user' ]

        let(:auth_token) { 'example_oauth_token' }
        run_test!
      end

      response '422', 'unprocessable entity' do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: [ 'error' ]

        let(:auth_token) { nil }
        run_test!
      end
    end
  end
end
