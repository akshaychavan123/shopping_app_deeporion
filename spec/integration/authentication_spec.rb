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


# require 'swagger_helper'

# RSpec.describe 'api/v1/auth', type: :request do
#   path '/api/v1/auth/login' do
#     post 'Logs in a user' do
#       tags 'Authentication'
#       consumes 'application/json'
#       parameter name: :credentials, in: :body, schema: {
#         type: :object,
#         properties: {
#           email: { type: :string },
#           password: { type: :string }
#         },
#         required: ['email', 'password']
#       }

#       response '200', 'OTP sent to email' do
#         let(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
#         let(:credentials) { { email: user.email, password: 'password' } }
#         run_test!
#       end

#       response '401', 'invalid credentials' do
#         let(:credentials) { { email: 'foo', password: 'bar' } }
#         run_test!
#       end
#     end
#   end

#   path '/api/v1/auth/verify_otp' do
#     post 'Verifies OTP and issues JWT token' do
#       tags 'Authentication'
#       consumes 'application/json'
#       parameter name: :otp_verification, in: :body, schema: {
#         type: :object,
#         properties: {
#           email: { type: :string },
#           otp: { type: :string }
#         },
#         required: ['email', 'otp']
#       }

#       response '200', 'JWT token issued' do
#         let(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password', otp_secret: ROTP::TOTP.new(ENV['OTP_SECRET'], issuer: "MyApp").now, otp_sent_at: Time.current) }
#         let(:otp_verification) { { email: user.email, otp: ROTP::TOTP.new(ENV['OTP_SECRET'], issuer: "MyApp").now } }
#         run_test!
#       end

#       response '401', 'invalid OTP' do
#         let(:otp_verification) { { email: 'john@example.com', otp: 'invalid' } }
#         run_test!
#       end
#     end
#   end
# end
