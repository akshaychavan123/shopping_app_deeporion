require 'swagger_helper'

RSpec.describe 'api/v2/products', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/products' do
    get('list products') do
      tags 'Products'
      # security [bearerAuth2: []]
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    path '/api/v2/products' do
      post('create product') do
        tags 'Products'
        security [bearerAuth2: []]
        consumes 'multipart/form-data'
        parameter name: :product, in: :formData, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            subcategory_id: { type: :integer },
            image: { type: :file }
          },
          required: ['image','name', 'subcategory_id']  
        }
    
        response(201, 'created') do
          let(:product) do
            {
              name: 'New Product',
              subcategory_id: create(:subcategory).id,
              image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
            }
          end
          run_test!
        end
    
        response(422, 'unprocessable entity') do
          let(:product) { { name: '', subcategory_id: create(:subcategory).id } }
          run_test!
        end
    
        response(401, 'unauthorized') do
          let(:Authorization) { 'Bearer invalid_token' }
          let(:product) { { name: 'New Product', subcategory_id: create(:subcategory).id } }
          run_test!
        end
      end
    end
    
  end

  path '/api/v2/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'ID'

    get('show product') do
      tags 'Products'
      security [bearerAuth2: []]
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

    path '/api/v2/products/{id}' do
      patch('update product') do
        tags 'Products'
        security [bearerAuth2: []]
        consumes 'multipart/form-data'
        parameter name: :id, in: :path, type: :integer, description: 'ID of the product to update'
        parameter name: :product, in: :formData, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            subcategory_id: { type: :integer },
            image: { type: :file },
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
    end    

    delete('delete product') do
      tags 'Products'
      security [bearerAuth2: []]

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
