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
          first_name: { type: :string },
          last_name: { type: :string },
          phone_number: { type: :string },
          email: { type: :string },
          country: { type: :string },
          pincode: { type: :string },
          area: { type: :string },
          city: { type: :string },
          state: { type: :string },
          address: { type: :string },
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
        required: ['first_name', 'last_name', 'phone_number', 'email', 'country', 'pincode', 'area', 'city', 'state', 'address', 'total_price', 'address_type', 'payment_status', 'placed_at', 'order_items_attributes']
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
end
