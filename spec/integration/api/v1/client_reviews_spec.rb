require 'swagger_helper'

RSpec.describe 'Client Reviews API', type: :request do
  path '/api/v1/client_reviews' do
    get 'List all client reviews' do
      tags 'ClientReviews'
      produces 'application/json'
      parameter name: :star, in: :query, type: :integer, description: 'Sort by star'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'

      response '200', 'Client reviews found' do
        run_test!
      end
    end

    post 'Create a client review' do
      tags 'ClientReviews'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :client_review, in: :body, schema: {
        type: :object,
        properties: {
          star: { type: :integer },
          review: { type: :string }
        },
        required: ['star', 'review']
      }

      response '201', 'Client review created' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end
    end
  end
end
