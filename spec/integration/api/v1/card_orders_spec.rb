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
              message: { type: :string },
              razorpay_order_id: { type: :string },
              razorpay_payment_id: { type: :string },
              payment_status: { type: :string },
              order_status: { type: :string }
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

  path '/api/v1/card_orders/callback' do
    post 'Verifies payment and updates order status' do
      tags 'Card Orders'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :callback_params, in: :body, schema: {
        type: :object,
        properties: {
          razorpay_payment_id: { type: :string },
          razorpay_order_id: { type: :string }
        },
        required: ['razorpay_payment_id', 'razorpay_order_id']
      }

      response '200', 'payment verified and email sent' do
        run_test!
      end

      response '404', 'order not found' do
        run_test!
      end

      response '422', 'payment failed' do
        run_test!
      end
    end
  end
end
