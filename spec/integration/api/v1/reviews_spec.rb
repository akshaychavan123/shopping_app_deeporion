require 'swagger_helper'

RSpec.describe 'Api::V1::Reviews', type: :request do
  path '/api/v1/reviews' do
    post('Create Review') do
      tags 'Reviews'
      security [bearerAuth: []]
      consumes 'multipart/form-data'
      parameter name: :review, in: :formData, schema: {
        type: :object,
        properties: {
          star: { type: :integer },
          images: {
              type: :array,
              items: { type: :string, format: :binary }
            },
          videos: {
              type: :array,
              items: { type: :string, format: :binary }
            },
          review: { type: :string },
          product_item_id: { type: :integer }
        },
        required: ['star', 'review', 'product_item_id']
      }

      response '201', 'created' do
        let(:Authorization) { "Bearer #{token}" }
        let(:product_item_id) { create(:product_item).id }
        let(:review) { { star: 5, review: 'Excellent product!', product_item_id: product_item_id } }
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:Authorization) { "Bearer #{token}" }
        let(:product_item_id) { create(:product_item).id }
        let(:review) { { star: nil, review: '', product_item_id: product_item_id } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:product_item_id) { create(:product_item).id }
        let(:Authorization) { 'Bearer invalid_token' }
        let(:review) { { star: 5, review: 'Excellent product!', product_item_id: product_item_id } }
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
      parameter name: :filter, in: :query, type: :string, description: 'Filter by popular, latest, or my_reviews', required: false    
      parameter name: :sort_by, in: :query, type: :string, description: 'positive, negative, recent'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'
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
              review: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: ['id', 'user_id', 'product_item_id', 'star', 'review', 'created_at', 'updated_at']
          }
        run_test!
      end

      response '404', 'not found' do
        let(:product_item_id) { 'invalid' }
        run_test!
      end
    end
  end
end
