require 'swagger_helper'

RSpec.describe 'Api::V2::ProductItemVariants', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user, type: 'Admin').id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/product_item_variants' do
    post('create product_item_variant') do
      tags 'Product Item Variants'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'

      parameter name: :product_item_variants, in: :formData, schema: {
        type: :object,
        properties: {
          price: { type: :number },
          size: { type: :string },
          quantity: { type: :number },
          product_item_id: { type: :integer },
          in_stock: { type: :boolean },
        },
        required: ['size','quantity','product_item_id', 'price']
      }

      response(201, 'created') do
        let(:product_item) { create(:product_item) }
        let(:data) do
          {
            product_item_id: product_item.id,
            color: 'Blue',
            price: 50.0,
            quantity:10
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:data) do
          {
            product_item_id: nil,
            color: 'Blue',
            price: 50.0,
            quantity:10
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:data) do
          {
            product_item_id: create(:product_item).id,
            color: 'Blue',
            price: 50.0,
            quantity:10
          }
        end
        run_test!
      end
    end
  end

  path '/api/v2/product_item_variants/{id}' do
  parameter name: :id, in: :path, type: :integer, description: 'ID of the product item'
    patch('update product_item_variants') do
      tags 'Product Item Variants'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'
      parameter name: :product_item_variants, in: :formData, schema: {
        type: :object,
          properties: {
            price: { type: :number },
            size: { type: :string },
            quantity: { type: :number },
            product_item_id: { type: :integer },
            in_stock: { type: :boolean },
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
      
    end
  end 

end
