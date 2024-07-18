require 'swagger_helper'

RSpec.describe 'Api::V2::ProductItemVariants', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/product_item_variants' do
    post('create product_item_variant') do
      tags 'Product Item Variants'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'
      parameter name: :product_item_variant, in: :formData, schema: {
        type: :object,
        properties: {
          product_item_id: { type: :integer },
          color: { type: :string },
          size: { type: :string },
          price: { type: :number },
          quantity: { type: :integer },
          photos: { type: :array, items: { type: :string, format: :binary } }
        },
        required: ['product_item_id', 'color', 'size', 'price', 'quantity']
      }

      response(201, 'created') do
        let(:product_item_variant) do
          {
            product_item_id: create(:product_item).id,
            color: 'Blue',
            size: 'M',
            price: 50.0,
            quantity: 10,
            photos: [
              Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
            ]
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:product_item_variant) { { product_item_id: nil } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:product_item_variant) { { product_item_id: create(:product_item).id } }
        run_test!
      end
    end
  end
end