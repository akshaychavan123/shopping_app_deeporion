require 'swagger_helper'

RSpec.describe 'Api::V2::ClientReviewComments', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user, type: 'Admin').id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/client_review_comments' do
    get('list client_review_comments') do
      tags 'Client Review Comments'
      security [bearerAuth2: []]
      description 'Fetch all client reviews with their comments'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'
      parameter name: :filter, in: :query, type: :string, description: 'positive, negative, recent'

      response(200, 'successful') do
        let(:client_review) { create(:client_review) }
        let!(:client_review_comment) { create(:client_review_comment, client_review: client_review) }

        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response).to be_an(Array)
          expect(json_response.first['id']).to eq(client_review.id)
          expect(json_response.first['client_review_comment']['comment']).to eq(client_review_comment.comment)
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response(500, 'internal server error') do
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  path '/api/v2/client_review_comments' do
    post('create client_review_comment') do
      tags 'Client Review Comments'
      security [bearerAuth2: []]
      consumes 'application/json'

      parameter name: :client_review_comment, in: :body, schema: {
        type: :object,
        properties: {
          client_review_id: { type: :integer },
          comment: { type: :string }
        },
        required: ['client_review_id', 'comment']
      }

      response(201, 'created') do
        let(:client_review) { create(:client_review) }
        let(:data) do
          {
            client_review_id: client_review.id,
            comment: 'Great review!'
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:client_review) { create(:client_review) }
        let(:data) do
          {
            client_review_id: client_review.id,
            comment: ''
          }
        end
        run_test!
      end

      response(404, 'review not found') do
        let(:data) do
          {
            client_review_id: -1,
            comment: 'Great review!'
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:data) do
          {
            client_review_id: create(:client_review).id,
            comment: 'Great review!'
          }
        end
        run_test!
      end
    end
  end

  path '/api/v2/client_review_comments/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the client review comment'
    patch('update client_review_comment') do
      tags 'Client Review Comments'
      security [bearerAuth2: []]
      consumes 'application/json'

      parameter name: :client_review_comment, in: :body, schema: {
        type: :object,
        properties: {
          comment: { type: :string }
        },
        required: ['comment']
      }

      response(200, 'successful') do
        let(:client_review_comment) { create(:client_review_comment) }
        let(:id) { client_review_comment.id }
        let(:data) do
          {
            comment: 'Updated review comment!'
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { create(:client_review_comment).id }
        let(:data) do
          {
            comment: ''
          }
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        let(:data) do
          {
            comment: 'Updated review comment!'
          }
        end
        run_test!
      end
    end

    delete('destroy client_review_comment') do
      tags 'Client Review Comments'
      security [bearerAuth2: []]

      response(200, 'successful') do
        let(:client_review_comment) { create(:client_review_comment) }
        let(:id) { client_review_comment.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        run_test!
      end
    end
  end
end
