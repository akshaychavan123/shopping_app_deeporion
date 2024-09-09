require 'swagger_helper'

RSpec.describe 'Api::V1::Carts', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/cart' do
    get 'Retrieves the user\'s cart' do
      tags 'Carts'
      security [bearerAuth: []]

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
  
  path '/api/v1/cart/discount_on_amount_coupons' do
    get 'List coupons with optional search by coupon code' do
      tags 'Carts'
      security [bearerAuth: []]
      produces 'application/json'
      parameter name: :coupon_code, in: :query, type: :string, description: 'Search by coupon code'
  
      response '200', 'successful' do
        run_test!
      end
    end
  end
  
  path '/api/v1/cart/apply_coupon' do
    post 'Applies a coupon to the cart' do
      tags 'Carts'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :promo_code, in: :query, type: :string, description: 'Coupon promo code'

      response '200', 'Coupon applied successfully' do
        let(:coupon) { create(:coupon, promo_code: 'DISCOUNT2024', promo_type: 'discount on amount', amount_off: 50) }
        let(:promo_code) { coupon.promo_code }
        let(:Authorization) { "Bearer #{token}" }

        schema type: :object,
          properties: {
            message: { type: :string },
            order_summary: {
              type: :object,
              properties: {
                subtotal: { type: :number },
                discount: { type: :number },
                taxes: { type: :number },
                delivery_charge: { type: :number },
                total: { type: :number }
              },
              required: %w[subtotal discount taxes delivery_charge total]
            }
          },
          required: %w[message order_summary]

        run_test!
      end

      response '422', 'Coupon is invalid or expired' do
        let(:promo_code) { 'INVALID2024' }
        let(:Authorization) { "Bearer #{token}" }

        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: ['error']

        run_test!
      end

      response '404', 'Coupon not found' do
        let(:promo_code) { 'NOTFOUND2024' }
        let(:Authorization) { "Bearer #{token}" }

        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: ['error']

        run_test!
      end
    end
  end
end
