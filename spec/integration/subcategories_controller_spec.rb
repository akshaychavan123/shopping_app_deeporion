require 'swagger_helper'

RSpec.describe 'api/v2/subcategories', type: :request do
  let(:category) { create(:category) }
  let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/categories/{category_id}/subcategories' do
    parameter name: 'category_id', in: :path, type: :integer, description: 'Category ID'

    get('list subcategories') do
      tags 'Subcategories'
      security [bearerAuth2: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:category_id) { category.id }
        run_test!
      end
    end

    post('create subcategory') do
      tags 'Subcategories'
      security [bearerAuth2: []]
      consumes 'application/json'
      parameter name: :subcategory, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(201, 'created') do
        let(:category_id) { category.id }
        let(:subcategory) { { name: 'New Subcategory' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:category_id) { category.id }
        let(:subcategory) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:category_id) { category.id }
        let(:subcategory) { { name: 'New Subcategory' } }
        run_test!
      end
    end
  end

  path '/api/v2/categories/{category_id}/subcategories/{id}' do
    parameter name: 'category_id', in: :path, type: :integer, description: 'Category ID'
    parameter name: 'id', in: :path, type: :integer, description: 'ID'

    get('show subcategory') do
      tags 'Subcategories'
      security [bearerAuth2: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        run_test!
      end

      response(404, 'not found') do
        let(:category_id) { category.id }
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        run_test!
      end
    end

    patch('update subcategory') do
      tags 'Subcategories'
      security [bearerAuth2: []]
      consumes 'application/json'
      parameter name: :subcategory, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(200, 'successful') do
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        let(:subcategory) { { name: 'Updated Subcategory' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        let(:subcategory) { { name: '' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        let(:subcategory) { { name: 'Updated Subcategory' } }
        run_test!
      end
    end

    delete('delete subcategory') do
      tags 'Subcategories'
      security [bearerAuth2: []]

      response(204, 'no content') do
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        run_test!
      end

      response(404, 'not found') do
        let(:category_id) { category.id }
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:category_id) { category.id }
        let(:id) { create(:subcategory, category: category).id }
        run_test!
      end
    end
  end
end
