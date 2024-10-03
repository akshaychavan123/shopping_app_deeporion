require 'swagger_helper'

RSpec.describe 'Api::V1::OrderItemsController', type: :request do
  path '/api/v1/order_items' do
      get('list order items') do
        tags 'Order Items'
        produces 'application/json'
        security [ bearerAuth2: [] ]
  
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

  path '/api/v1/order_items/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Order Item ID'
  
    delete('delete order item') do
      tags 'Order Items'
      produces 'application/json'
      security [ bearerAuth2: [] ]
  
      response(200, 'order item successfully deleted') do
        let(:id) { OrderItem.create(product_item_id: 1, quantity: 2, price: 100.0, status: 'pending').id }
  
        run_test!
      end
  
      response(404, 'order item not found') do
        let(:id) { 'invalid' }
  
        run_test!
      end
  
      response(422, 'unprocessable entity') do
        let(:order_item) { OrderItem.create(product_item_id: 1, quantity: 2, price: 100.0, status: 'pending') }
        before do
          allow_any_instance_of(OrderItem).to receive(:destroy).and_return(false)
          order_item.errors.add(:base, 'Cannot delete order item')
        end
        let(:id) { order_item.id }
  
        run_test!
      end
    end
  end
end
