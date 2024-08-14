require 'swagger_helper'

RSpec.describe 'api/v2/privacy_policies', type: :request do

  path '/api/v2/privacy_policies' do

    get('list privacy policies') do
      tags 'Privacy Policies'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create privacy policy') do
      tags 'Privacy Policies'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :privacy_policy, in: :body, schema: {
        type: :object,
        properties: {
          privacy_policy: {
            type: :object,
            properties: {
              heading: { type: :string },
              description: { type: :string }
            },
            required: %w[heading description]
          }
        }
      }

      response(201, 'created') do
        let(:privacy_policy) { { privacy_policy: { heading: 'New Policy', description: 'Policy description' } } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:privacy_policy) { { privacy_policy: { heading: nil, description: nil} } }
        run_test!
      end
    end
  end

  path '/api/v2/privacy_policies/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID of the privacy policy'

    get('show privacy policy') do
      tags 'Privacy Policies'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { PrivacyPolicy.create(heading: 'Policy', description: 'Description').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update privacy policy') do
      tags 'Privacy Policies'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :privacy_policy, in: :body, schema: {
        type: :object,
        properties: {
          privacy_policy: {
            type: :object,
            properties: {
              heading: { type: :string },
              description: { type: :string },
            }
          }
        }
      }

      response(200, 'updated') do
        let(:id) { PrivacyPolicy.create(heading: 'Policy', description: 'Description').id }
        let(:privacy_policy) { { privacy_policy: { heading: 'Updated Policy' } } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { PrivacyPolicy.create(heading: 'Policy', description: 'Description').id }
        let(:privacy_policy) { { privacy_policy: { heading: nil } } }
        run_test!
      end
    end

    delete('delete privacy policy') do
      tags 'Privacy Policies'
      security [bearerAuth2: []]

      response(204, 'no content') do
        let(:id) { PrivacyPolicy.create(heading: 'Policy', description: 'Description').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
