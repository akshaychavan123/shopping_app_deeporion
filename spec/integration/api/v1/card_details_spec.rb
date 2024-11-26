require 'swagger_helper'

RSpec.describe 'api/v1/card_details', type: :request do
  let!(:user) { create(:user) }
  let!(:card_detail) { create(:card_detail, user: user) }
  let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

  path '/api/v1/card_details' do
    get 'Retrieves Card Detail' do
      tags 'CardDetails'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'card details found' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            holder_name: { type: :string },
            card_number: { type: :string },
            expiry_date: { type: :string },
            cvv: { type: :string }
          },
          required: %w[id holder_name card_number expiry_date cvv]
        }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end

    post 'Creates Card Details' do
      tags 'CardDetails'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :card_detail, in: :body, schema: {
        type: :object,
        properties: {
          holder_name: { type: :string },
          card_number: { type: :string },
          expiry_date: { type: :string },
          cvv: { type: :string },
          card_type: { type: :string }
        },
        required: %w[holder_name card_number expiry_date cvv type]
      }

      response '201', 'card detail created' do
        let(:card_detail) { { holder_name: 'John Doe', card_number: '1234567890123456', expiry_date: '12/25', cvv: '123' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:card_detail) { { holder_name: 'John Doe' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/card_details' do
    put 'Updates Card Details' do
      tags 'CardDetails'
      security [bearerAuth: []]
      consumes 'application/json'
      # parameter name: :id, in: :path, type: :integer
      parameter name: :card_detail, in: :body, schema: {
        type: :object,
        properties: {
          holder_name: { type: :string },
          card_number: { type: :string },
          expiry_date: { type: :string },
          cvv: { type: :string },
          card_type: { type: :string }
        },
        required: %w[holder_name card_number expiry_date cvv type]
      }

      response '200', 'card detail updated' do
        let(:id) { card_detail.id }
        let(:card_detail) { { holder_name: 'Jane Doe', card_number: '6543210987654321', expiry_date: '01/30', cvv: '321' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { card_detail.id }
        let(:card_detail) { { holder_name: '' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end

    delete 'Deletes Card Details' do
      tags 'CardDetails'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '200', 'card detail deleted' do
        let(:id) { card_detail.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
