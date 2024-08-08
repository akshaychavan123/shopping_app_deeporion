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

    # path '/api/v1/cart/cart_items/{id}' do
    #   patch 'Updates a cart item' do
    #     tags 'Cart Items'
    #     security [bearerAuth: []]
    #     consumes 'application/json'
    #     parameter name: :id, in: :path, type: :integer
    #     parameter name: :cart_item, in: :body, schema: {
    #       type: :object,
    #       properties: {
    #         quantity: { type: :integer }
    #       },
    #       required: ['quantity']
    #     }
  
    #     response '200', 'cart item updated' do
    #       let(:id) { create(:cart_item, cart: user.cart).id }
    #       let(:cart_item) { { quantity: 2 } }
  
    #       run_test!
    #     end
  
    #     response '401', 'unauthorized' do
    #       let(:Authorization) { nil }
    #       let(:id) { create(:cart_item).id }
    #       let(:cart_item) { { quantity: 2 } }
  
    #       run_test!
    #     end
  
    #     response '422', 'invalid params' do
    #       let(:id) { create(:cart_item, cart: user.cart).id }
    #       let(:cart_item) { { quantity: -1 } }
  
    #       run_test!
    #     end
    #   end
    # end

    path '/api/v1/cart/cart_items/{id}' do
      patch 'Updates a cart item' do
        tags 'Cart Items'
        security [bearerAuth: []]
        consumes 'application/json'
        parameter name: :id, in: :path, type: :integer
        parameter name: :cart_item, in: :body, schema: {
          type: :object,
          properties: {
            quantity: { type: :integer },
            product_item_variant_id: { type: :integer }
          },
          required: ['quantity', 'product_item_variant_id']
        }
    
        response '200', 'cart item updated' do
          let(:user) { create(:user) }
          let(:cart) { create(:cart, user: user) }
          let(:product_item) { create(:product_item) }
          let(:product_item_variant) { create(:product_item_variant, product_item: product_item) }
          let(:cart_item) { create(:cart_item, cart: cart, product_item_variant: product_item_variant) }
    
          let(:id) { cart_item.id }
          let(:cart_item) { { quantity: 2, product_item_variant_id: product_item_variant.id } }
    
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['cart_item']['quantity']).to eq(2)
            expect(data['cart_item']['product_item_variant_id']).to eq(product_item_variant.id)
            expect(data['available_sizes']).not_to be_empty
          end
        end
    
        response '401', 'unauthorized' do
          let(:Authorization) { nil }
          let(:user) { create(:user) }
          let(:cart) { create(:cart, user: user) }
          let(:product_item) { create(:product_item) }
          let(:product_item_variant) { create(:product_item_variant, product_item: product_item) }
          let(:cart_item) { create(:cart_item, cart: cart, product_item_variant: product_item_variant) }
    
          let(:id) { cart_item.id }
          let(:cart_item) { { quantity: 2, product_item_variant_id: product_item_variant.id } }
    
          run_test!
        end
    
        response '422', 'invalid params' do
          let(:user) { create(:user) }
          let(:cart) { create(:cart, user: user) }
          let(:product_item) { create(:product_item) }
          let(:product_item_variant) { create(:product_item_variant, product_item: product_item) }
          let(:cart_item) { create(:cart_item, cart: cart, product_item_variant: product_item_variant) }
    
          let(:id) { cart_item.id }
          let(:cart_item) { { quantity: -1, product_item_variant_id: product_item_variant.id } }
    
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
            product_item_id: { type: :integer },
            # quantity: { type: :integer }
          },
          required: ['product_item_id']
        }
  
        response '200', 'item added to cart' do
          let(:product_item_id) { create(:product_item_id).id }
          let(:quantity) { 1 }
  
          let(:cart_item) { { product_item_id: product_item_id} }
  
          run_test!
        end
  
        response '401', 'unauthorized' do
          let(:Authorization) { nil }
          let(:cart_item) { { product_item_id: create(:product_item_id).id } }
  
          run_test!
        end
  
        response '404', 'product item not found' do
          let(:product_item_id) { 'invalid' }
          let(:cart_item) { { product_item_id: product_item_id} }
  
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
            product_item_id: { type: :integer },
            action_type: { type: :string, enum: ['remove', 'wishlist'] }
          },
          required: ['product_item_id', 'action_type']
        }
  
        response '200', 'item removed or moved to wishlist' do
          let(:product_item_id) { create(:product_item_id).id }
          let(:action_type) { 'remove' }
  
          let(:cart_item) { { product_item_id: product_item_id, action_type: action_type } }
  
          run_test!
        end
  
        response '401', 'unauthorized' do
          let(:Authorization) { nil }
          let(:cart_item) { { product_item_id: create(:product_item_id).id, action_type: 'remove' } }
  
          run_test!
        end
  
        response '404', 'item not found in cart' do
          let(:product_item_id) { 'invalid' }
          let(:action_type) { 'remove' }
  
          let(:cart_item) { { product_item_id: product_item_id, action_type: action_type } }
  
          run_test!
        end
  
        response '400', 'invalid action type' do
          let(:product_item_id) { create(:product_item).id }
          let(:action_type) { 'invalid' }
  
          let(:cart_item) { { product_item_id: product_item_id, action_type: action_type } }
  
          run_test!
        end
      end
    end
  end

  path '/api/v1/cart/cart_items/{id}/size_list' do
    get 'Retrieves size list for a product item' do
      tags 'Cart Items'
      security [bearerAuth: []]
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the product item'

      response '200', 'sizes retrieved successfully' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              size: { type: :string }
            },
            required: [:id, :size]
          }

        let(:product_item) { create(:product_item) }
        let!(:product_item_variants) do
          create_list(:product_item_variant, 3, product_item: product_item)
        end

        let(:id) { product_item.id }
        before do
          get "/api/v1/cart/cart_items/#{id}/size_list", headers: { 'Authorization' => "Bearer #{token}" }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.first).to have_key('id')
          expect(data.first).to have_key('size')
        end
      end

      response '404', 'product item not found' do
        let(:id) { 'invalid' }

        before do
          get "/api/v1/cart/cart_items/#{id}/size_list", headers: { 'Authorization' => "Bearer #{token}" }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Product Item not found')
        end
      end

      response '401', 'unauthorized' do
        let(:id) { create(:product_item).id }

        before do
          get "/api/v1/cart/cart_items/#{id}/size_list", headers: { 'Authorization' => nil }
        end

        run_test!
      end
    end
  end
end
