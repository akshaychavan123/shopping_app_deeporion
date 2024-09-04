require 'swagger_helper'

RSpec.describe 'api/v2/terms_and_conditions', type: :request do
  path '/api/v2/terms_and_conditions' do
    get 'Retrieves all terms and conditions' do
      tags 'TermsAndConditions'
      produces 'application/json'
      response '200', 'terms and conditions found' do
        run_test!
      end
    end

    post 'Creates a terms and condition' do
      tags 'TermsAndConditions'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :terms_and_condition, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        },
        required: ['description']
      }

      response '201', 'terms and condition created' do
        let(:terms_and_condition) { { description: 'These are the terms...' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:terms_and_condition) { { description: '' } }
        run_test!
      end

      response '403', 'Unauthorized access' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:terms_and_condition) { { description: 'These are the terms...' } }
        run_test!
      end
    end
  end

  path '/api/v2/terms_and_conditions/{id}' do
    get 'Retrieves a terms and condition' do
      tags 'TermsAndConditions'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'terms and condition found' do
        let(:id) { TermsAndCondition.create(description: 'These are the terms...').id }
        run_test!
      end

      response '404', 'terms and condition not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a terms and condition' do
      tags 'TermsAndConditions'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :id, in: :path, type: :integer
      parameter name: :terms_and_condition, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        },
        required: ['description']
      }

      response '200', 'terms and condition updated' do
        let(:id) { TermsAndCondition.create(description: 'These are the terms...').id }
        let(:terms_and_condition) { { description: 'Updated terms'} }
        run_test!
      end

      response '404', 'terms and condition not found' do
        let(:id) { 'invalid' }
        let(:terms_and_condition) { { description: 'Updated terms'} }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { TermsAndCondition.create(description: 'These are the terms...').id }
        let(:terms_and_condition) { { description: '' } }
        run_test!
      end

      response '403', 'Unauthorized access' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { TermsAndCondition.create(description: 'These are the terms...').id }
        let(:terms_and_condition) { { description: 'Updated terms'} }
        run_test!
      end
    end

    delete 'Deletes a terms and condition' do
      tags 'TermsAndConditions'
      security [bearerAuth2: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'terms and condition deleted' do
        let(:id) { TermsAndCondition.create(description: 'These are the terms...').id }
        run_test!
      end

      response '404', 'terms and condition not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '403', 'Unauthorized access' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { TermsAndCondition.create(description: 'These are the terms...').id }
        run_test!
      end
    end
  end
end
