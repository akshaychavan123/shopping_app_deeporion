require 'swagger_helper'

RSpec.describe 'Api::V1::Passwords', type: :request do

  path '/api/v1/passwords/forgot' do
    post('Forgot password') do
      tags 'Passwords'
      consumes 'application/json'
      parameter name: :email, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: [ 'email' ]
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
