require 'swagger_helper'

RSpec.describe 'Api::V2::ExchangeReturnPoliciesController', type: :request do
  path '/api/v2/exchange_return_policies' do
    get 'Retrieves all Exchange & Return Policies' do
      tags 'Exchange & Return Policies'
      produces 'application/json'
      response '200', 'exchange_return_policy found' do
        run_test!
      end
    end

    post 'Creates an Exchange & Return Policy' do
      tags 'Exchange & Return Policies'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :exchange_return_policy, in: :body, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string }
        },
        required: ['heading', 'description']
      }
      response '201', 'exchange_return_policy created' do
        let(:exchange_return_policy) { { heading: 'Return Policy', description: 'You can return items within 30 days.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:exchange_return_policy) { { heading: nil, description: 'You can return items within 30 days.' } }
        run_test!
      end
    end
  end

  path '/api/v2/exchange_return_policies/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Retrieves a specific Exchange & Return Policy' do
      tags 'Exchange & Return Policies'
      produces 'application/json'
      response '200', 'exchange_return_policy found' do
        let(:id) { ExchangeReturnPolicy.create(heading: 'Return Policy', description: 'You can return items within 30 days.').id }
        run_test!
      end

      response '404', 'exchange_return_policy not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a specific Exchange & Return Policy' do
      tags 'Exchange & Return Policies'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :exchange_return_policy, in: :body, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string }
        },
        required: ['heading', 'description']
      }
      response '200', 'exchange_return_policy updated' do
        let(:id) { ExchangeReturnPolicy.create(heading: 'Return Policy', description: 'You can return items within 30 days.').id }
        let(:exchange_return_policy) { { heading: 'Updated Policy', description: 'You can return items within 60 days.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { ExchangeReturnPolicy.create(heading: 'Return Policy', description: 'You can return items within 30 days.').id }
        let(:exchange_return_policy) { { heading: nil } }
        run_test!
      end
    end

    delete 'Deletes a specific Exchange & Return Policy' do
      tags 'Exchange & Return Policies'
      security [bearerAuth2: []]
      response '204', 'exchange_return_policy deleted' do
        let(:id) { ExchangeReturnPolicy.create(heading: 'Return Policy', description: 'You can return items within 30 days.').id }
        run_test!
      end

      response '404', 'exchange_return_policy not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '422', 'cannot delete exchange_return_policy' do
        let(:exchange_return_policy) { ExchangeReturnPolicy.create(heading: 'Return Policy', description: 'You can return items within 30 days.') }
        let(:id) { exchange_return_policy.id }
        before do
          allow_any_instance_of(ExchangeReturnPolicy).to receive(:destroy).and_return(false)
          exchange_return_policy.errors.add(:base, 'Cannot delete exchange_return_policy entry')
        end
        run_test!
      end
    end
  end
end
