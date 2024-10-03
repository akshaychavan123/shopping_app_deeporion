require 'swagger_helper'

RSpec.describe 'api/v1/plans', type: :request do
  path '/api/v1/plans' do
    get 'Retrieves all Plans' do
      tags 'Plans'
      consumes 'application/json'
      security [bearerAuth: []]

      response '200', 'plans retrieved' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    post 'Creates an Plan' do
      tags 'Plans'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
            name: { type: :string },
            service: { type: :string },
            amount: { type: :integer },
            frequency: { type: :string},
            discription: { type: :string }
        },
        required: ['name']
      }

      response '201', 'address created' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:plan) { { name: 'Tessa' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:plan) { { name: 'Tessa' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:plan) { { name: 'Tessa' } }
        run_test!
      end
    end
  end

  path '/api/v1/plans/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Plan ID'

    get 'Retrieves a specific Plan' do
      tags 'Plans'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'plan found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        run_test!
      end

      response '404', 'plan not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        run_test!
      end
    end

    put 'Updates an Plan' do
      tags 'Plans'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
            name: { type: :string },
            service: { type: :string },
            amount: { type: :integer },
            frequency: { type: :string},
            discription: { type: :string }
        }
      }

      response '200', 'plan updated' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '404', 'plan not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        let(:plan) { { plan: 'New City' } }
        run_test!
      end
    end

    delete 'Deletes an Plan' do
      tags 'Plans'
      security [bearerAuth: []]

      response '200', 'plan deleted' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        run_test!
      end

      response '404', 'plan not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        run_test!
      end
    end
  end
end
