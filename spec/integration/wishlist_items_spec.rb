require 'swagger_helper'

RSpec.describe 'Api::V1::WishlistItems', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/wishlists/{wishlist_id}/wishlist_items' do
    post 'Creates a wishlist item' do
      tags 'Wishlist Items'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :wishlist_item, in: :body, schema: {
        type: :object,
        properties: {
          product_item_id: { type: :integer, description: 'ID of the product item' }
        },
        required: ['product_item_id']
      }
  
      response '201', 'wishlist item created' do
        let(:wishlist_id) { create(:wishlist, user: user).id }
        let(:product_item_id) { create(:product_item_id).id }
        let(:wishlist_item) { { product_item_id: product_item_id } }
  
        run_test!
      end
  
      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:wishlist_id) { create(:wishlist).id }
        let(:product_item_id) { create(:product_item_id).id }
        let(:wishlist_item) { { product_item_id: product_item_id } }
  
        run_test!
      end
  
      response '422', 'invalid params' do
        let(:wishlist_id) { create(:wishlist, user: user).id }
        let(:product_item_id) { nil }
        let(:wishlist_item) { { product_item_id: product_item_id } }
  
        run_test!
      end
    end
  end  

  path '/api/v1/wishlists/:wishlist_id/wishlist_items/{id}' do
    delete 'Deletes a wishlist item' do
      tags 'Wishlist Items'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer

      response '204', 'wishlist item deleted' do
        let(:wishlist_id) { create(:wishlist, user: user).id }
        let(:id) { create(:wishlist_item, wishlist: Wishlist.find(wishlist_id)).id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:wishlist_id) { create(:wishlist).id }
        let(:id) { create(:wishlist_item, wishlist: Wishlist.find(wishlist_id)).id }

        run_test!
      end
    end
  end

  path '/api/v1/wishlists/:wishlist_id/wishlist_items/add_to_cart' do
    post 'Moves an item from wishlist to cart' do
      tags 'Wishlist Items'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :wishlist_item, in: :body, schema: {
        type: :object,
        properties: {
          product_item_id: { type: :integer }
        },
        required: ['product_item_id']
      }

      response '200', 'item added to cart' do
        let(:wishlist_id) { create(:wishlist, user: user).id }
        let(:wishlist_item) { create(:wishlist_item, wishlist: Wishlist.find(wishlist_id)) }
        let(:product_item_id) { wishlist_item.product_item_id.id }
        let(:wishlist_item_params) { { product_item_id: product_item_id } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:wishlist_id) { create(:wishlist).id }
        let(:product_item_id) { create(:product_item_id).id }
        let(:wishlist_item_params) { { product_item_id: product_item_id } }

        run_test!
      end

      response '404', 'item not found in wishlist' do
        let(:wishlist_id) { create(:wishlist, user: user).id }
        let(:product_item_id) { 'invalid' }
        let(:wishlist_item_params) { { product_item_id: product_item_id } }

        run_test!
      end
    end
  end
end
