require 'swagger_helper'

RSpec.describe 'Api::V2::GiftCardCategories', type: :request do

  path '/api/v2/gift_card_categories' do
    get('list gift_card_categories') do
      tags 'GiftCardCategories'
      produces 'application/json'
      security [ bearerAuth2: [] ]

      response(200, 'successful') do
        run_test!
      end
    end

    post('create gift_card_category') do
      tags 'GiftCardCategories'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'
      parameter name: :gift_card_category, in: :formData, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: ['title']
      }
  
      response(201, 'created') do
        let(:gift_card_category) do
          {
            title: 'New Category',
            image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
          }
        end
        run_test!
      end
  
      response(422, 'unprocessable entity') do
        let(:gift_card_category) { { title: '' } }
        run_test!
      end
  
      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:gift_card_category) { { title: 'New Category' } }
        run_test!
      end
    end
  end

  path '/api/v2/gift_card_categories/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show gift_card_category') do
      tags 'GiftCardCategories'
      produces 'application/json'
      security [ bearerAuth2: [] ]

      response(200, 'successful') do
        let(:id) { GiftCardCategory.create(title: 'New Category').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete('delete gift_card_category') do
      tags 'GiftCardCategories'
      security [ bearerAuth2: [] ]

      response(204, 'no content') do
        let(:id) { GiftCardCategory.create(title: 'New Category').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
