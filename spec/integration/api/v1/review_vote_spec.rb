require 'swagger_helper'

RSpec.describe 'Api::V1::ReviewVotes', type: :request do
  path '/api/v1/review_votes' do
    post('Create Review Vote') do
      tags 'Review Votes'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :review_vote, in: :body, schema: {
        type: :object,
        properties: {
          helpful: { type: :boolean },
          review_id: { type: :integer }

        },
        required: ['helpful', 'review_id']
      }

      response '201', 'created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:review_id) { create(:review).id }
        let(:review_vote) { { helpful: true } }
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:Authorization) { "Bearer #{token}" }
        let(:review_id) { create(:review).id }
        let(:review_vote) { { helpful: nil } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:review_id) { create(:review).id }
        let(:Authorization) { 'Bearer invalid_token' }
        let(:review_vote) { { helpful: true } }
        run_test!
      end
    end
  end
end
