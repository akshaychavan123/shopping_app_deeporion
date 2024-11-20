require 'swagger_helper'

RSpec.describe 'Api::V2::ContactUsManage', type: :request do
  path '/api/v2/contact_us_manage' do
    get 'Retrieve all ContactUs entries' do
      tags 'ContactUs Management'
      security [bearerAuth2: []]
      produces 'application/json'

      response '200', 'ContactUs list retrieved successfully' do
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Invalid token' }
        run_test!
      end
    end
  end

  path '/api/v2/contact_us_manage/{id}' do
    get 'Retrieve a specific ContactUs entry' do
      tags 'ContactUs Management'
      security [bearerAuth2: []]
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ContactUs ID'

      response '200', 'ContactUs entry retrieved successfully' do
        run_test!
      end

      response '404', 'ContactUs entry not found' do
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end

    patch 'Update a specific ContactUs entry' do
      tags 'ContactUs Management'
      security [bearerAuth2: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ContactUs ID'
      parameter name: :contact_us, in: :body, schema: {
        type: :object,
        properties: {
          contact_us: {
            type: :object,
            properties: {
              status: { type: :string, example: 'resolved' },
              comment: { type: :string, example: 'Resolved successfully' }
            },
            required: %w[status]
          }
        }
      }

      response '200', 'ContactUs entry updated successfully' do
        run_test!
      end

      response '404', 'ContactUs entry not found' do
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    end
  end
end
