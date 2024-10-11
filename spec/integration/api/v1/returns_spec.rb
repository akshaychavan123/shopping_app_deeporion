require 'swagger_helper'

RSpec.describe 'Api::V1::Returns', type: :request do
  path '/api/v1/returns' do
    post 'Creates a return for an order item' do
      tags 'Returns'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :return_params, in: :body, schema: {
        type: :object,
        properties: {
          order_id: { type: :integer, example: 1 },
          order_item_id: { type: :integer, example: 15 },
          address_id: { type: :integer, example: 1 },
          reason: { type: :string, example: 'Damaged product' },
          refund_method: { type: :string, example: 'card' },
          more_information: { type: :string, example: 'Product arrived broken.' }
        },
        required: ['order_id', 'order_item_id', 'address_id', 'reason']
      }

      response '201', 'Return processed successfully' do
        let(:Authorization) { "Bearer #{create(:user).auth_token}" }
        let(:return_params) do
          {
            order_id: create(:order, user: create(:user)).id,
            order_item_id: create(:order_item).id,
            address_id: create(:address).id,
            reason: 'Damaged product',
            refund_method: 'card',
            more_information: 'Product was broken'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Return processed successfully')
          expect(data['return']).not_to be_nil
        end
      end

      response '404', 'Order or item not found' do
        let(:Authorization) { "Bearer #{create(:user).auth_token}" }
        let(:return_params) { { order_id: 999, order_item_id: 999, address_id: 999, reason: 'Damaged product' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Order or item not found')
        end
      end

      response '422', 'Unprocessable entity' do
        let(:Authorization) { "Bearer #{create(:user).auth_token}" }
        let(:return_params) do
          {
            order_id: create(:order).id,
            order_item_id: create(:order_item).id,
            address_id: create(:address).id,
            reason: '',
            refund_method: '',
            more_information: 'Product was broken'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).not_to be_nil
        end
      end
    end
  end
end