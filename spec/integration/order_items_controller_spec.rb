require 'swagger_helper'

RSpec.describe 'Api::V1::OrderItemsController', type: :request do
  path '/api/v1/order_items' do
    get('list order items') do
      tags 'Order Items'
      produces 'application/json'
      security [ bearerAuth2: [] ]
       parameter name: :status, in: :query, type: :string, 
                description: 'Filter by multiple statuses (comma-separated). (e.g., pending, out_for_delivery, delivered, cancelled)'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/order_items/pending_orders/{status}' do
    parameter name: 'status', in: :path, type: :string
    get('list pending items') do
      tags 'Order Items'
      produces 'application/json'
      security [ bearerAuth2: [] ]

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/order_items/order_count' do
    get('list order counts') do
      tags 'Order Items'
      produces 'application/json'
      security [ bearerAuth2: [] ]
      parameter name: :start_date, in: :query, type: :string, format: :date, required: false,
      description: 'Start date for filtering orders (format: YYYY-MM-DD)'
      parameter name: :end_date, in: :query, type: :string, format: :date, required: false,
      description: 'End date for filtering orders (format: YYYY-MM-DD)'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/order_items/order_status_graph' do
    get('order status graph details') do
      tags 'Order Items'
      produces 'application/json'
      security [ bearerAuth2: [] ]

      parameter name: :start_date, in: :query, type: :string, required: false,
      description: 'Start date for the filter (format: DD/MM/YYYY)'
      parameter name: :end_date, in: :query, type: :string, required: false,
      description: 'End date for the filter (format: DD/MM/YYYY)'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/order_items/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Order Item ID'
    
    put('update order item') do
      tags 'Order Items'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth2: [] ]

      parameter name: :order_item, in: :body, schema: {
        type: :object,
        properties: {
          status: {type: :string}
        },
        required: ['status']
      }

      response(200, 'successful') do
        let(:order_item) { { product_item_id: 1, quantity: 2, price: 100.0, status: 'pending' } }
        let(:id) { OrderItem.create(product_item_id: 1, quantity: 2, price: 100.0, status: 'pending').id }

        run_test!
      end

      response(404, 'order item not found') do
        let(:id) { 'invalid' }
        let(:order_item) { { product_item_id: 1, quantity: 2, price: 100.0, status: 'pending' } }
        
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:order_item) { { product_item_id: nil, quantity: 2, price: 100.0, status: 'pending' } }
        let(:id) { OrderItem.create(product_item_id: 1, quantity: 2, price: 100.0, status: 'pending').id }

        run_test!
      end
    end
  end

  path '/api/v1/order_items/revenue_graph' do
    get('revenue graph details') do
      tags 'Order Items'
      produces 'application/json'
      security [ bearerAuth2: [] ]

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/order_items/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'order item ID'
          
    delete 'Deletes an order item' do
      tags 'Order Items'
      security [bearerAuth2: []]

      response '200', 'order deleted' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:order_item, user: @user).id }
        run_test!
      end

      response '404', 'order item not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:order_item).id }
        run_test!
      end
    end
  end
end
