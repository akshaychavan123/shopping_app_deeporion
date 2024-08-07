require 'swagger_helper'

RSpec.describe 'Api::V2::ShippingPoliciesController', type: :request do
  path '/api/v2/shipping_policies' do
    get 'Retrieves all Shipping Policies' do
      tags 'Shipping Policies'
      produces 'application/json'
      response '200', 'shipping_policy found' do
        run_test!
      end
    end

    post 'Creates a Shipping Policy' do
      tags 'Shipping Policies'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :shipping_policy, in: :body, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string }
        },
        required: ['heading', 'description']
      }
      response '201', 'shipping_policy created' do
        let(:shipping_policy) { { heading: 'Shipping Policy', description: 'Items are shipped within 5 business days.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:shipping_policy) { { heading: nil, description: 'Items are shipped within 5 business days.' } }
        run_test!
      end
    end
  end

  path '/api/v2/shipping_policies/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Retrieves a specific Shipping Policy' do
      tags 'Shipping Policies'
      produces 'application/json'
      response '200', 'shipping_policy found' do
        let(:id) { ShippingPolicy.create(heading: 'Shipping Policy', description: 'Items are shipped within 5 business days.').id }
        run_test!
      end

      response '404', 'shipping_policy not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a specific Shipping Policy' do
      tags 'Shipping Policies'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :shipping_policy, in: :body, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string }
        },
        required: ['heading', 'description']
      }
      response '200', 'shipping_policy updated' do
        let(:id) { ShippingPolicy.create(heading: 'Shipping Policy', description: 'Items are shipped within 5 business days.').id }
        let(:shipping_policy) { { heading: 'Updated Policy', description: 'Items are shipped within 3 business days.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { ShippingPolicy.create(heading: 'Shipping Policy', description: 'Items are shipped within 5 business days.').id }
        let(:shipping_policy) { { heading: nil } }
        run_test!
      end
    end

    delete 'Deletes a specific Shipping Policy' do
      tags 'Shipping Policies'
      security [bearerAuth2: []]
      response '204', 'shipping_policy deleted' do
        let(:id) { ShippingPolicy.create(heading: 'Shipping Policy', description: 'Items are shipped within 5 business days.').id }
        run_test!
      end

      response '404', 'shipping_policy not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '422', 'cannot delete shipping_policy' do
        let(:shipping_policy) { ShippingPolicy.create(heading: 'Shipping Policy', description: 'Items are shipped within 5 business days.') }
        let(:id) { shipping_policy.id }
        before do
          allow_any_instance_of(ShippingPolicy).to receive(:destroy).and_return(false)
          shipping_policy.errors.add(:base, 'Cannot delete shipping_policy entry')
        end
        run_test!
      end
    end
  end
end
