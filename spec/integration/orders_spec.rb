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
          coupon_id: { type: :integer }
        },
        required: ['total_price', 'address_id', 'order_items_attributes']
      }

      response '201', 'Order created successfully' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
        let(:order) do
          {
            total_price: 500.0,
            address_id: 1
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

  path '/api/v1/orders/cancel' do
    post('Cancel Order') do
      tags 'Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :query, type: :integer, description: 'Order ID'
      parameter name: :order_item_id, in: :body, schema: {
        type: :object,
        properties: {
          order_item_id: { type: :integer },
          reason: { type: :string, description: 'Please write a reason for cancel order' },
          more_information: { type: :string, description: 'More Information' }
        },
        required: ['order_item_id', 'reason']
      }
      response '200', 'Order canceled successfully' do
        let!(:order) { create(:order, user: user, payment_status: 'created') }
        let(:id) { order.id }
        run_test! 
      end

      response '422', 'Order cannot be canceled' do
        let!(:order) { create(:order, user: user, payment_status: 'paid', status: 'delivered') }
        let(:id) { order.id }
        run_test! 
      end

      response '404', 'Order not found' do
        let(:id) { 'invalid' }
        run_test! 
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let!(:order) { create(:order, user: user) }
        let(:id) { order.id }
        run_test!
      end
    end
  end

  path '/api/v1/orders/exchange_order' do
    post 'Handles exchange request for an order item' do
      tags 'Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :order_id, in: :query, type: :integer, description: 'Order ID', required: true
      parameter name: :order_item_id, in: :query, type: :integer, description: 'Order Item ID', required: true
      parameter name: :reason, in: :body, schema: {
        type: :object,
        properties: {
          reason: { type: :string, description: 'Reason for exchange request' },
          more_information: { type: :string, description: 'Additional information for the exchange' }
        },
        required: ['reason']
      }

      response '200', 'Exchange request created successfully' do
        run_test! 
      end

      response '404', 'Order or Order Item not found' do
        run_test! 
      end

      response '422', 'Invalid request or exchange not allowed' do
        run_test! 
      end

      response '422', 'Exchange already in process or cannot be exchanged' do
        run_test! 
      end

      response '401', 'Unauthorized' do
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

  path '/api/v1/orders/order_item_details' do
    get 'Fetch order item details' do
      tags 'Orders'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :order_id, in: :query, type: :integer, required: true, description: 'Order ID'
      parameter name: :order_item_id, in: :query, type: :integer, required: true, description: 'Order Item ID'
  

      response '200', 'Order item details retrieved successfully' do
        run_test!
      end

      response '404', 'Order not found' do
        run_test!
      end

      response '404', 'Order item not found' do
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end
end
