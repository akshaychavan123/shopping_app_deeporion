require 'swagger_helper'

RSpec.describe 'Api::V2::GiftCards', type: :request do

  path '/api/v2/gift_cards' do
    get('list gift_cards') do
      tags 'GiftCards'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response(200, 'successful') do
        run_test!
      end
    end

    post('create gift_card') do
      tags 'GiftCards'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :gift_card, in: :body, schema: {
        type: :object,
        properties: {
          gift_card: {
            type: :object,
            properties: {
              image: { type: :string },
              price: { type: :number, format: :decimal },
              gift_card_category_id: { type: :integer }
            },
            required: [ 'image', 'price', 'gift_card_category_id' ]
          }
        },
        required: [ 'gift_card' ]
      }

      response(201, 'created') do
        let(:gift_card) { { gift_card: { image: 'image_url', price: 50.0, gift_card_category_id: 1 } } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:gift_card) { { gift_card: { image: '', price: '', gift_card_category_id: '' } } }
        run_test!
      end
    end
  end

  path '/api/v2/gift_cards/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show gift_card') do
      tags 'GiftCards'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response(200, 'successful') do
        let(:id) { GiftCard.create(image: 'image_url', price: 50.0, gift_card_category_id: 1).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update gift_card') do
      tags 'GiftCards'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :gift_card, in: :body, schema: {
        type: :object,
        properties: {
          gift_card: {
            type: :object,
            properties: {
              image: { type: :string },
              price: { type: :number, format: :decimal },
              gift_card_category_id: { type: :integer }
            }
          }
        },
        required: [ 'gift_card' ]
      }

      response(200, 'successful') do
        let(:id) { GiftCard.create(image: 'image_url', price: 50.0, gift_card_category_id: 1).id }
        let(:gift_card) { { gift_card: { image: 'new_image_url', price: 60.0 } } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { GiftCard.create(image: 'image_url', price: 50.0, gift_card_category_id: 1).id }
        let(:gift_card) { { gift_card: { image: '', price: '' } } }
        run_test!
      end
    end

    delete('delete gift_card') do
      tags 'GiftCards'
      security [ bearerAuth: [] ]

      response(204, 'no content') do
        let(:id) { GiftCard.create(image: 'image_url', price: 50.0, gift_card_category_id: 1).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
