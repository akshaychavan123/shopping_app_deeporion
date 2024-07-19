require 'swagger_helper'

RSpec.describe 'Api::V1::CartItems', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/cart/cart_items' do
    get 'Retrieves cart items' do
      tags 'Cart Items'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'cart items found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              quantity: { type: :integer },
              product_item: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  brand: { type: :string },
                  price: { type: :number },
                  description: { type: :string }
                },
                required: [:id, :name, :brand, :price, :description]
              }
            },
            required: [:id, :quantity, :product_item]
          }

        before { create_list(:cart_item, 3, cart: user.cart) }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end

    path '/api/v1/cart/cart_items/{id}' do
      patch 'Updates a cart item' do
        tags 'Cart Items'
        security [bearerAuth: []]
        consumes 'application/json'
        parameter name: :id, in: :path, type: :integer
        parameter name: :cart_item, in: :body, schema: {
          type: :object,
          properties: {
            quantity: { type: :integer }
          },
          required: ['quantity']
        }
  
        response '200', 'cart item updated' do
          let(:id) { create(:cart_item, cart: user.cart).id }
          let(:cart_item) { { quantity: 2 } }
  
          run_test!
        end
  
        response '401', 'unauthorized' do
          let(:Authorization) { nil }
          let(:id) { create(:cart_item).id }
          let(:cart_item) { { quantity: 2 } }
  
          run_test!
        end
  
        response '422', 'invalid params' do
          let(:id) { create(:cart_item, cart: user.cart).id }
          let(:cart_item) { { quantity: -1 } }
  
          run_test!
        end
      end
    end
  
    path '/api/v1/cart/cart_items/add_item' do
      post 'Adds an item to the cart' do
        tags 'Cart Items'
        security [bearerAuth: []]
        consumes 'application/json'
        parameter name: :cart_item, in: :body, schema: {
          type: :object,
          properties: {
            product_item_variant_id: { type: :integer },
            # quantity: { type: :integer }
          },
          required: ['product_item_variant_id']
        }
  
        response '200', 'item added to cart' do
          let(:product_item_variant_id) { create(:product_item_variant_id).id }
          let(:quantity) { 1 }
  
          let(:cart_item) { { product_item_variant_id: product_item_variant_id} }
  
          run_test!
        end
  
        response '401', 'unauthorized' do
          let(:Authorization) { nil }
          let(:cart_item) { { product_item_variant_id: create(:product_item_variant_id).id } }
  
          run_test!
        end
  
        response '404', 'product item not found' do
          let(:product_item_variant_id) { 'invalid' }
          let(:cart_item) { { product_item_variant_id: product_item_variant_id} }
  
          run_test!
        end
      end
    end
  
    path '/api/v1/cart/cart_items/remove_or_move_to_wishlist' do
      delete 'Removes or moves an item to wishlist' do
        tags 'Cart Items'
        security [bearerAuth: []]
        consumes 'application/json'
        parameter name: :cart_item, in: :body, schema: {
          type: :object,
          properties: {
            product_item_variant_id: { type: :integer },
            action_type: { type: :string, enum: ['remove', 'wishlist'] }
          },
          required: ['product_item_variant_id', 'action_type']
        }
  
        response '200', 'item removed or moved to wishlist' do
          let(:product_item_variant_id) { create(:product_item_variant_id).id }
          let(:action_type) { 'remove' }
  
          let(:cart_item) { { product_item_variant_id: product_item_variant_id, action_type: action_type } }
  
          run_test!
        end
  
        response '401', 'unauthorized' do
          let(:Authorization) { nil }
          let(:cart_item) { { product_item_variant_id: create(:product_item_variant_id).id, action_type: 'remove' } }
  
          run_test!
        end
  
        response '404', 'item not found in cart' do
          let(:product_item_variant_id) { 'invalid' }
          let(:action_type) { 'remove' }
  
          let(:cart_item) { { product_item_variant_id: product_item_variant_id, action_type: action_type } }
  
          run_test!
        end
  
        response '400', 'invalid action type' do
          let(:product_item_variant_id) { create(:product_item).id }
          let(:action_type) { 'invalid' }
  
          let(:cart_item) { { product_item_variant_id: product_item_variant_id, action_type: action_type } }
  
          run_test!
        end
      end
    end
  end
end
