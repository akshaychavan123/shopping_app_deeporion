require 'swagger_helper'

RSpec.describe 'api/v1/orders', type: :request do
  path '/api/v1/orders/save_order_data' do
    post 'Saves an order data' do
      tags 'Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :order_items, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          total_price: { type: :number },
          address_id: { type: :integer },
          email: { type: :string },
          payment_status: { type: :string },
          razorpay_payment_id: { type: :string },
          razorpay_order_id: { type: :string },
          order_items_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                product_item_id: { type: :integer },
                quantity: { type: :integer },
                product_item_variant_id: { type: :number },
                status: { type: :string },
                total_price: { type: :number },
            }
          }
        },
        required: ['total_price', 'address_id', 'payment_status', 'user_id','order_items_attributes']
      }}

      response '201', 'order created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:order) { 
          {
            user_id: 1,
            total_price: '23',
            address_id: '1',
            email: 'john.doe@example.com',
            payment_status: 'completed',
            razorpay_payment_id: '12345',
            razorpay_order_id: '234',
            order_items_attributes: [
              { product_item_id: 1, quantity: 2, price: 20.0, product_item_variant_id:1 },
              { product_item_id: 2, quantity: 1, price: 10.0,  product_item_variant_id:1 }
            ]
          }
        }
        run_test!
      end
    end
  end

  path '/api/v1/orders/order_history' do
    get 'Retrieves the order history for the current user' do
      tags 'Orders'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'order history found' do
        let(:Authorization) { "Bearer #{token}" }
        let(:user) { create(:user) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let!(:orders) do
          create_list(:order, 3, user: user).each do |order|
            create(:order_item, order: order)
          end
        end

        run_test! do
          expect(json.size).to eq(3)
        end
      end

      response '404', 'no orders found' do
        let(:Authorization) { "Bearer #{token}" }
        let(:user) { create(:user) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        
        run_test! do
          expect(json['message']).to eq('No orders found')
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }

        run_test! do
          expect(json['errors']).to eq('Unauthorized')
        end
      end
    end
  end
end
