require 'swagger_helper'

RSpec.describe 'Client Reviews API', type: :request do
  path '/api/v1/client_reviews' do
    get 'List all client reviews' do
      tags 'ClientReviews'
      produces 'application/json'
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

  path '/api/v1/client_reviews/{id}' do
    put 'Update a client review' do
      tags 'ClientReviews'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, description: 'Client review ID'
      parameter name: :client_review, in: :body, schema: {
        type: :object,
        properties: {
          star: { type: :integer },
          review: { type: :string }
        },
        required: ['star', 'review']
      }

      response '200', 'Client review updated' do
        let(:current_user) { create(:user) }
        let!(:client_review) { ClientReview.create!(user: current_user, star: 3, review: 'Original review') }
        let(:id) { client_review.id }
        run_test!
      end

      response '403', 'Unauthorized' do
        let(:unauthorized_user) { create(:user) }
        let!(:client_review) { ClientReview.create!(user: unauthorized_user, star: 3, review: 'Original review') }
        let(:id) { client_review.id }
        let(:client_review) { { star: 5, review: 'Updated review by another user' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:current_user) { create(:user) }
        let!(:client_review) { ClientReview.create!(user: current_user, star: 3, review: 'Original review') }
        let(:id) { client_review.id }
        let(:client_review) { { star: nil, review: 'Invalid review' } }
        run_test!
      end
    end
  end
end
