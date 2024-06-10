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

  # path '/users/{id}' do

  #   get 'Retrieves a user' do
  #     tags 'Users'
  #     produces 'application/json'
  #     parameter name: :id, :in => :path, :type => :string

  #     response '200', 'user found' do
  #       schema type: :object,
  #         properties: {
  #           id: { type: :integer },
  #           name: { type: :string },
  #           email: { type: :string }
  #         },
  #         required: ['id', 'name', 'email']

  #       let(:id) { User.create(name: 'test', email: 'test@example.com', password: 'password').id }
  #       run_test!
  #     end

  #     response '404', 'user not found' do
  #       let(:id) { 'invalid' }
  #       run_test!
  #     end
  #   end
  # end
end
