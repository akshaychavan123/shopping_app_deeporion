require 'swagger_helper'

RSpec.describe 'api/v1/orders', type: :request do
  path '/api/v1/orders' do
    post 'Creates an order' do
      tags 'Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          total_price: { type: :number },
          address_type: { type: :string },
          payment_status: { type: :string },
          placed_at: { type: :string, format: 'date-time' },
          order_items_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                product_item_id: { type: :integer },
                quantity: { type: :integer },
                sub_total: { type: :number }
              }
            }
          }
        },
        required: ['total_price', 'address_type', 'payment_status', 'placed_at', 'order_items_attributes']
      }

      response '201', 'order created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:order) { 
          {
            first_name: 'John',
            last_name: 'Doe',
            phone_number: '1234567890',
            email: 'john.doe@example.com',
            country: 'USA',
            pincode: '12345',
            area: 'Downtown',
            city: 'Los Angeles',
            state: 'CA',
            address: '123 Main St',
            total_price: 100.0,
            address_type: 'Home',
            payment_status: 'pending',
            placed_at: '2023-06-01T12:00:00Z',
            order_items_attributes: [
              { product_item_id: 1, quantity: 2, sub_total: 20.0 },
              { product_item_id: 2, quantity: 1, sub_total: 10.0 }
            ]
          }
        }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{token}" } 
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:order) { { first_name: 'John' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:order) { { first_name: 'John', last_name: 'Doe', phone_number: '1234567890', email: 'john.doe@example.com', country: 'USA', pincode: '12345', area: 'Downtown', city: 'Los Angeles', state: 'CA', address: '123 Main St', total_price: 100.0, address_type: 'Home', payment_status: 'pending', placed_at: '2023-06-01T12:00:00Z', order_items_attributes: [{ product_item_id: 1, quantity: 2, sub_total: 20.0 }, { product_item_id: 2, quantity: 1, sub_total: 10.0 }] } }
        run_test!
      end
    end
  end



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

end
