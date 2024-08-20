require 'swagger_helper'

RSpec.describe 'api/v1/card_orders', type: :request do
  path '/api/v1/card_orders' do
    post 'Creates a new card order' do
      tags 'Card Orders'
      consumes 'application/json'
      security [bearerAuth: []]
      
      parameter name: :card_order, in: :body, schema: {
        type: :object,
        properties: {
          card_order: {
            type: :object,
            properties: {
              gift_card_id: { type: :integer },
              recipient_name: { type: :string },
              recipient_email: { type: :string, format: :email },
              dob: { type: :string, format: :date },
              sender_email: { type: :string, format: :email },
              message: { type: :string }
            },
            required: ['gift_card_id', 'recipient_name', 'recipient_email', 'sender_email']
          }
        },
        required: ['card_order']
      }

      response '201', 'card order created' do
        let(:gift_card) { create(:gift_card) }
        let(:card_order) { { card_order: { gift_card_id: gift_card.id, recipient_name: 'John Doe', recipient_email: 'john@example.com', dob: '1990-01-01', sender_email: 'sender@example.com', message: 'Happy Birthday!' } } }
        run_test!
      end

      response '404', 'gift card not found' do
        let(:card_order) { { card_order: { gift_card_id: 0, recipient_name: 'John Doe', recipient_email: 'john@example.com', dob: '1990-01-01', sender_email: 'sender@example.com', message: 'Happy Birthday!' } } }
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:gift_card) { create(:gift_card) }
        let(:card_order) { { card_order: { gift_card_id: gift_card.id, recipient_name: '', recipient_email: 'invalid', sender_email: 'sender@example.com', message: 'Happy Birthday!' } } }
        run_test!
      end
    end
  end
end
