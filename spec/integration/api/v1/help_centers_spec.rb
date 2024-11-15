require 'swagger_helper'

RSpec.describe '/api/v1/help_centers', type: :request do
  path '/api/v1/help_centers' do
    get 'Retrieves all Help Center' do
      tags 'Help Center'
      consumes 'application/json'
      security [bearerAuth: []]

      response '200', 'Help Center retrieved' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    post 'Creates an Help Center' do
      tags 'Help Center'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
            question: { type: :string },
            answer: { type: :string },
            description: { type: :integer }
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

  path '/api/v1/help_centers/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'HELP CENTER ID'

    get 'Retrieves a specific Help Center' do
      tags 'Help Center'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Help Center found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        run_test!
      end

      response '404', 'Help Center not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        run_test!
      end
    end

    put 'Updates an Help Center' do
      tags 'Help Center'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
            question: { type: :string },
            answer: { type: :string },
            description: { type: :integer }
        }
      }

      response '200', 'Help Center updated' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '404', 'Help Center not found' do
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

    delete 'Deletes an Help Center' do
      tags 'Help Center'
      security [bearerAuth: []]

      response '200', 'Help Center deleted' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        run_test!
      end

      response '404', 'Help Center not found' do
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
