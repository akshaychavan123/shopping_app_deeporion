require 'swagger_helper'

RSpec.describe 'Api::V2::ProductItems', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/product_items' do
    get('list product_items') do
      tags 'Product Items'
      security [bearerAuth2: []]
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    path '/api/v2/product_items' do
      post('create product_item') do
        tags 'Product Items'
        security [bearerAuth2: []]
        consumes 'multipart/form-data'
        parameter name: :product_item, in: :formData, schema: {
          type: :object,
          properties: {
            image: { type: :file },
            product_id: { type: :integer },
            name: { type: :string },
            brand: { type: :string },
            price: { type: :number },
            description: { type: :string },
            material: { type: :string },
            care: { type: :string },
            product_code: { type: :string },
          },
          required: ['name', 'brand', 'description', 'product_code', 'product_id']
        }
    
        response(201, 'created') do
          let(:product_item) do
            {
              product_id: create(:product).id,
              name: 'New Product',
              brand: 'Brand',
              price: 50.0,
              description: 'Description',
              material: 'Cotton',
              care: 'Machine wash',
              product_code: 'Code123',
              image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
            }
          end
          run_test!
        end
    
        response(422, 'unprocessable entity') do
          let(:product_item) { { name: '' } }
          run_test!
        end
    
        response(401, 'unauthorized') do
          let(:Authorization) { 'Bearer invalid_token' }
          let(:product_item) { { name: 'New Product' } }
          run_test!
        end
      end
    end    
  end

  path '/api/v2/product_items/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the product item'

    get('retrieve product_item') do
      tags 'Product Items'
      security [bearerAuth2: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { create(:product_item).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        run_test!
      end
    end

    patch('update product_item') do
      tags 'Product Items'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'
      parameter name: :product_item, in: :formData, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          brand: { type: :string },
          description: { type: :string },
          material: { type: :string },
          care: { type: :string },
          product_code: { type: :string },
          product_id: { type: :integer }
        }
      }

      response(200, 'successful') do
        let(:id) { create(:product_item).id }
        let(:product_item) { { name: 'Updated Product' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { create(:product_item).id }
        let(:product_item) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { create(:product_item).id }
        let(:product_item) { { name: 'Updated Product' } }
        run_test!
      end
    end

    delete('delete product_item') do
      tags 'Product Items'
      security [bearerAuth2: []]

      response(204, 'no content') do
        let(:id) { create(:product_item).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { create(:product_item).id }
        run_test!
      end
    end
  end
end
