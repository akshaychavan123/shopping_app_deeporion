require 'swagger_helper'

RSpec.describe 'Api::V1::LandingPage', type: :request do
  path '/api/v1/landing_page/categories_index' do
    get('list categories') do
      tags 'Landing Page'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

	path '/api/v1/landing_page/sub_categories_index' do
    get('list subcategories') do
      tags 'Landing Page'
      produces 'application/json'
      parameter name: :id, in: :query, type: :integer, description: 'Category ID'

      response(200, 'successful') do
        let(:id) { create(:category).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/products_index' do
    get('list products') do
      tags 'Landing Page'
      produces 'application/json'
      parameter name: :id, in: :query, type: :integer, description: 'Subcategory ID'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_index' do
    get('list product items') do
      tags 'Landing Page'
      produces 'application/json'
      parameter name: :id, in: :query, type: :integer, description: 'Product ID'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/gift_cards_index' do
    get('list gift cards') do
      tags 'Landing Page'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_of_product/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the product item'

    get('retrieve product_item') do
      tags 'Landing Page'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { create(:product_item).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_show/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the product item'

    get('retrieve product_item') do
      tags 'Landing Page'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { create(:product_item).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { -1 }
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_filter' do
    get('list and filter product items') do
      tags 'Landing Page'
      produces 'application/json'
      
      parameter name: :subcategory_id, in: :query, type: :integer, description: 'ID of the subcategory'
      parameter name: :product_id, in: :query, type: :integer, description: 'ID of the product'
      parameter name: :brand, in: :query, type: :string, description: 'Brand of the product item'
      parameter name: :size, in: :query, type: :string, description: 'Size of the product item'
      parameter name: :color, in: :query, type: :string, description: 'Color of the product item'
      parameter name: :min_price, in: :query, type: :number, format: :float, description: 'Minimum price of the product item'
      parameter name: :max_price, in: :query, type: :number, format: :float, description: 'Maximum price of the product item'
      parameter name: :search, in: :query, type: :string, description: 'Search term for the product item name or description'

      response(200, 'successful') do
        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end
  end
end
