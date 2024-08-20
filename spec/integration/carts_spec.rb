require 'swagger_helper'

RSpec.describe 'Api::V1::Carts', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/cart' do
    get 'Retrieves the user\'s cart' do
      tags 'Carts'
      security [bearerAuth: []]  # Adjusted to match your security definition

      produces 'application/json'

      response '200', 'cart found' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

        schema type: :object,
          properties: {
            id: { type: :integer },
            user_id: { type: :integer },
            cart_items: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  quantity: { type: :integer },
                  product_item: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      brand: { type: :string },
                      price: { type: :number },
                      description: { type: :string }
                    },
                    required: [:id, :name, :brand, :price, :description]
                  }
                },
                required: [:id, :quantity, :product_item]
              }
            }
          },
          required: ['id', 'user_id', 'cart_items']

        before { create_list(:cart_item, 3, cart: user.cart) }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/cart/product_item_list_by_coupon/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the coupon'
  
    get('list associated products') do
      tags 'Carts'
      security [bearerAuth: []]
      consumes 'application/json'
  
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array
                 }
               }
        run_test!
      end
  
      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
  
  path '/api/v1/cart/coupon_list' do
    get('list coupons') do
      tags 'Carts'
      security [bearerAuth: []]
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
