require 'swagger_helper'

RSpec.describe 'Api::V2::ProductItemVariants', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user, type: 'Admin').id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/product_item_variants' do
    post('create product_item_variant') do
      tags 'Product Item Variants'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'

      parameter name: :data, in: :formData, schema: {
        type: :object,
        properties: {
          color: { type: :string },
          price: { type: :number },
          product_item_id: { type: :integer },
          photos: {
            type: :array,
            items: { type: :string, format: :binary }
          },
          sizes_attributes: {
            type: :object,
            additionalProperties: {
              type: :object,
              properties: {
                size_name: { type: :string },
                price: { type: :number },
                quantity: { type: :integer }
              },
              required: ['size_name', 'price', 'quantity']
            }
          }
        },
        required: ['product_item_id', 'color', 'price']
      }

      response(201, 'created') do
        let(:product_item) { create(:product_item) }
        let(:data) do
          {
            product_item_id: product_item.id,
            color: 'Blue',
            price: 50.0,
            photos: [
              Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
            ],
            sizes_attributes: {
              "0" => { size_name: 'L', price: 55.0, quantity: 5 },
              "1" => { size_name: 'XL', price: 60.0, quantity: 3 }
            }
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
            sizes_attributes: {
              "0" => { size_name: 'L', price: 55.0, quantity: 5 }
            }
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
            price: 50.0
          }
        end
        run_test!
      end
    end
  end
end
