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

end
