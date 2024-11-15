require 'swagger_helper'

RSpec.describe 'api/v2/product_review_manage', type: :request do
  path '/api/v2/product_review_manage' do
    get('list reviews') do
      tags 'Admin Reviews'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :category_id, in: :query, type: :integer, description: 'Category ID'
      security [bearerAuth2: []]

      response(200, 'successful') do
        run_test!
      end

      response(404, 'category not found') do
        run_test!
      end
    end
  end

  path '/api/v2/product_review_manage/{id}' do
    delete('delete review') do
      tags 'Admin Reviews'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth2: []]
      parameter name: :id, in: :path, type: :integer, description: 'Review ID'

      response(200, 'review deleted successfully') do
        run_test!
      end

      response(404, 'review not found') do
        run_test!
      end
    end
  end

  path '/api/v2/product_review_manage/{id}/hide_review' do
    patch('hide review') do
      tags 'Admin Reviews'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth2: []]
      parameter name: :id, in: :path, type: :integer, description: 'Review ID'

      response(200, 'review hidden successfully') do
        run_test!
      end

      response(404, 'review not found') do
        run_test!
      end
    end
  end

  path '/api/v2/product_review_manage/{id}/product_reviews' do
    get('fetch product reviews') do
      tags 'Admin Reviews'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth2: []]
      parameter name: :id, in: :path, type: :integer, description: 'Product Item ID'
      parameter name: :sort_by, in: :query, type: :string, description: 'Sort reviews by criteria (positive, negative, recent, hidden)'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of reviews per page'

      response(200, 'successful') do
        run_test!
      end

      response(404, 'product item not found') do
        run_test!
      end
    end
  end
end
