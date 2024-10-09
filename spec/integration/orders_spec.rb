require 'swagger_helper'

RSpec.describe 'api/v1/orders', type: :request do

  path '/api/v1/orders' do
    post 'Creates an order and generates Razorpay order' do
      tags 'Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          total_price: { type: :number },
          address_id: { type: :integer },
          order_items_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                product_item_id: { type: :integer },
                product_item_variant_id: { type: :integer },
                quantity: { type: :integer },
                total_price: { type: :number },
              }
            }
          }
        },
        required: ['total_price', 'address_id', 'order_items_attributes']
      }

      response '201', 'Order created successfully' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:order) do
          {
            total_price: 500.0,
            address_id: 1,
            order_items_attributes: [
              { product_item_id: 1, product_item_variant_id: 1, quantity: 2, total_price: 250.0 },
              { product_item_id: 2, product_item_variant_id: 2, quantity: 1, total_price: 250.0 }
            ]
          }
        end
        run_test!
      end

      response '422', 'Invalid request' do
        let(:Authorization) { "Bearer #{token}" }
        let(:order) do
          {
            total_price: nil,
            address_id: nil
          }
        end
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end

  path '/api/v1/orders/callback' do
    post 'Handles Razorpay payment callback' do
      tags 'Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :callback, in: :body, schema: {
        type: :object,
        properties: {
          razorpay_payment_id: { type: :string },
          razorpay_order_id: { type: :string },
          order_id: { type: :integer }
        },
        required: ['razorpay_payment_id', 'razorpay_order_id', 'order_id']
      }

      response '200', 'Payment successful' do
        let(:Authorization) { "Bearer #{token}" }
        let(:callback) do
          {
            razorpay_payment_id: 'pay_29QQoUBi66xm2f',
            razorpay_order_id: 'order_9A33XWu170gUtm',
            order_id: 1
          }
        end
        run_test!
      end

      response '422', 'Payment verification failed' do
        let(:Authorization) { "Bearer #{token}" }
        let(:callback) do
          {
            razorpay_payment_id: 'invalid_payment',
            razorpay_order_id: 'invalid_order',
            order_id: 1
          }
        end
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
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
