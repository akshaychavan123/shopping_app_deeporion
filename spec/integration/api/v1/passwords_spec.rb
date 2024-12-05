require 'swagger_helper'

RSpec.describe 'Api::V1::Passwords', type: :request do

  path '/api/v1/passwords/forgot' do
    post('Forgot password') do
      tags 'Passwords'
      consumes 'application/json'
      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          type: {
            type: :string,
            enum: ['user', 'admin'],
            description: 'Specifies whether the email is for an admin or a user'
          }
        },
        required: ['email', 'type']
      }

      response '200', 'Password reset link sent' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'Link sent to your email' }
               },
               required: ['status']

        run_test!
      end

      response '400', 'Bad Request' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Email not present' }
               },
               required: ['error']

        run_test!
      end

      response '404', 'Not Found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Email address not found. Please check and try again.' }
               },
               required: ['error']

        run_test!
      end

      response '429', 'Too Many Requests' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'You can only request a reset link once every 30 seconds.' }
               },
               required: ['error']

        run_test!
      end

      response '403', 'Unauthorized Access to Admin Email' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Unauthorized email for admin password reset.' }
               },
               required: ['error']

        run_test!
      end
    end
  end

  path '/api/v1/passwords/reset' do
    post('Reset password') do
      tags 'Passwords'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: [ 'token', 'password', 'password_confirmation' ]
      }
  
      response '200', 'OK' do
        schema type: :object,
          properties: {
            status: { type: :string }
          },
          required: [ 'status' ]
  
        run_test!
      end
  
      response '404', 'Not Found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: [ 'error' ]
  
        run_test!
      end
  
      response '422', 'Unprocessable Entity' do
        schema type: :object,
          properties: {
            error: {
              type: :array,
              items: { type: :string }
            }
          },
          required: [ 'error' ]
  
        run_test!
      end
    end
  end
end
