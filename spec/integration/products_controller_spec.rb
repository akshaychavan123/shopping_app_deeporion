require 'swagger_helper'

RSpec.describe 'api/v2/products', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/products' do
    get('list products') do
      tags 'Products'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create product') do
      tags 'Products'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(201, 'created') do
        let(:product) { { name: 'New Product' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:product) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:product) { { name: 'New Product' } }
        run_test!
      end
    end
  end

  path '/api/v2/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'ID'

    get('show product') do
      tags 'Products'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { create(:product).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { create(:product).id }
        run_test!
      end
    end

    patch('update product') do
      tags 'Products'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(200, 'successful') do
        let(:id) { create(:product).id }
        let(:product) { { name: 'Updated Product' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { create(:product).id }
        let(:product) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { create(:product).id }
        let(:product) { { name: 'Updated Product' } }
        run_test!
      end
    end

    delete('delete product') do
      tags 'Products'
      security [bearerAuth: []]

      response(204, 'no content') do
        let(:id) { create(:product).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { create(:product).id }
        run_test!
      end
    end
  end
end
