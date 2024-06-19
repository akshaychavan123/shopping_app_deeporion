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

  path '/api/v1/auth/create' do
    post 'Creates a user with phone number' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          phone_number: { type: :string }
        },
        required: ['phone_number']
      }

      response '201', 'User created and verification code sent' do
        let(:user) { { phone_number: '+1234567890' } }
        run_test!
      end

      response '422', 'Invalid user data' do
        let(:user) { { phone_number: '' } }
        run_test!
      end

      response '422', 'Phone number already exists' do
        before do
          create(:user, phone_number: '+1234567890')
        end
        let(:user) { { phone_number: '+1234567890' } }
        run_test!
      end
    end 
  end

  describe 'POST /api/v1/auth/verify' do
    let!(:user) { create(:user, phone_number: '+1234567890') }

    path '/api/v1/auth/verify' do
      post 'Verifies phone number' do
        tags 'Authentication'
        consumes 'application/json'
        parameter name: :verification, in: :body, schema: {
          type: :object,
          properties: {
            user_id: { type: :integer },
            verification_code: { type: :string }
          },
          required: %w[user_id verification_code]
        }

        response '201', 'Phone number verified' do
          let(:verification) { { user_id: user.id, verification_code: user.phone_verification_code } }
          run_test!
        end

        response '401', 'Invalid verification code' do
          let(:verification) { { user_id: user.id, verification_code: '123456' } }
          run_test!
        end
      end
    end
  end
end
