require 'swagger_helper'

RSpec.describe 'api/v2/categories', type: :request do
  path '/api/v2/categories' do
    get('list categories') do
      tags 'Categories'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        run_test!
      end
    end

    post('create category') do
      tags 'Categories'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(201, 'created') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:category) { { name: 'New Category' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:category) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:category) { { name: 'New Category' } }
        run_test!
      end
    end
  end

  path '/api/v2/categories/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID'

    get('show category') do
      tags 'Categories'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:id) { Category.create(name: 'Sample Category').id }
        run_test!
      end

      response(404, 'not found') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { Category.create(name: 'Sample Category').id }
        run_test!
      end
    end

    patch('update category') do
      tags 'Categories'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(200, 'successful') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:id) { Category.create(name: 'Sample Category').id }
        let(:category) { { name: 'Updated Category' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:id) { Category.create(name: 'Sample Category').id }
        let(:category) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { Category.create(name: 'Sample Category').id }
        let(:category) { { name: 'Updated Category' } }
        run_test!
      end
    end

    delete('delete category') do
      tags 'Categories'
      security [bearerAuth: []]

      response(204, 'no content') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:id) { Category.create(name: 'Sample Category').id }
        run_test!
      end

      response(404, 'not found') do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { Category.create(name: 'Sample Category').id }
        run_test!
      end
    end
  end
end
