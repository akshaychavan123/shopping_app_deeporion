require 'swagger_helper'

RSpec.describe 'api/v1/wishlist_items', type: :request do
  let(:user) { create(:user) }
  let(:wishlist) { create(:wishlist, user: user) }
  let(:product_item) { create(:product_item) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/wishlists/{wishlist_id}/wishlist_items' do
    parameter name: 'wishlist_id', in: :path, type: :integer, description: 'Wishlist ID'

    post('create wishlist_item') do
      tags 'WishlistItems'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :wishlist_item, in: :body, schema: {
        type: :object,
        properties: {
          product_item_id: { type: :integer }
        },
        required: ['product_item_id']
      }

      response(201, 'created') do
        let(:wishlist_id) { wishlist.id }
        let(:wishlist_item) { { product_item_id: product_item.id } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:wishlist_id) { wishlist.id }
        let(:wishlist_item) { { product_item_id: nil } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:wishlist_id) { wishlist.id }
        let(:wishlist_item) { { product_item_id: product_item.id } }
        run_test!
      end
    end
  end

  path '/api/v1/wishlist_items/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Wishlist Item ID'

    delete('delete wishlist_item') do
      tags 'WishlistItems'
      security [bearerAuth: []]

      response(204, 'no content') do
        let(:id) { create(:wishlist_item, wishlist: wishlist, product_item: product_item).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { create(:wishlist_item, wishlist: wishlist, product_item: product_item).id }
        run_test!
      end
    end
  end
end
