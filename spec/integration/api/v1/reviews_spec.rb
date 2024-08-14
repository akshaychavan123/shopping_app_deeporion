require 'swagger_helper'

RSpec.describe 'Api::V1::Reviews', type: :request do
  path '/api/v1/reviews' do
    post('Create Review') do
      tags 'Reviews'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :review, in: :body, schema: {
        type: :object,
        properties: {
          star: { type: :integer },
          recommended: { type: :boolean },
          review: { type: :string },
          product_item_id: { type: :integer }
        },
        required: ['star', 'recommended', 'review', 'product_item_id']
      }

      response '201', 'created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:product_item_id) { create(:product_item).id }
        let(:review) { { star: 5, recommended: true, review: 'Excellent product!', product_item_id: product_item_id } }
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:Authorization) { "Bearer #{token}" }
        let(:product_item_id) { create(:product_item).id }
        let(:review) { { star: nil, recommended: nil, review: '', product_item_id: product_item_id } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:product_item_id) { create(:product_item).id }
        let(:Authorization) { 'Bearer invalid_token' }
        let(:review) { { star: 5, recommended: true, review: 'Excellent product!', product_item_id: product_item_id } }
        run_test!
      end
    end
  end

  path '/api/v1/reviews' do
    get('List Reviews') do
      tags 'Reviews'
      produces 'application/json'
      security [bearerAuth: []]
      parameter name: :product_item_id, in: :query, type: :integer, description: 'Product Item ID', required: false

      response '200', 'successful' do
        let(:product_item_id) { create(:product_item).id }
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              user_id: { type: :integer },
              product_item_id: { type: :integer },
              star: { type: :integer },
              recommended: { type: :boolean },
              review: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: ['id', 'user_id', 'product_item_id', 'star', 'recommended', 'review', 'created_at', 'updated_at']
          }
        run_test!
      end

      response '404', 'not found' do
        let(:product_item_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/reviews/show_all_review' do
    get 'List All Reviews' do
      tags 'Reviews'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'
  
      response '200', 'successful' do
        run_test!
      end
  
      response '404', 'not found' do
        run_test!
      end
    end
  end  
end
