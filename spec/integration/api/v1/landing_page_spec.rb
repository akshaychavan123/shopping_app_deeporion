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

  path '/api/v1/landing_page/index_with_subcategories_and_products' do
    get('list index_with_subcategories_and_products') do
      tags 'Landing Page'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_by_category/{id}' do
    get('Get product items by category') do
      tags 'Landing Page'
      description 'Fetches all product items associated with a specific category.'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the category to fetch product items for', required: true
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'
  
      response(200, 'successful') do
        let(:id) { create(:category).id }
        run_test!
      end
  
      response(404, 'category not found') do
        let(:id) { 'invalid' }
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
    parameter name: :id, in: :path, type: :integer, description: 'ID of the product'

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
      parameter name: :search, in: :query, type: :string, description: 'Search term for the product item name, brand, color, or material'

      response(200, 'successful') do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  brand: { type: :string },
                  product_id: { type: :integer },
                  price_of_variant: { type: :number, format: :float },
                  id_of_first_variant: { type: :integer },
                  one_image_of_variant: { type: :string },
                  rating_and_review: { type: :string, nullable: true }
                }
              }
            }
          },
          required: [ 'data' ]

        let(:subcategory_id) { nil }
        let(:product_id) { nil }
        let(:brand) { nil }
        let(:size) { nil }
        let(:color) { nil }
        let(:min_price) { nil }
        let(:max_price) { nil }
        let(:search) { nil }

        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string }
            }
          },
          required: [ 'errors' ]

        run_test!
      end

      response(422, 'unprocessable entity') do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string }
            }
          },
          required: [ 'errors' ]

        let(:search) { ' ' }

        run_test!
      end
    end
  end

  path '/api/v1/landing_page/new_arrivals' do
    get('new arrivals') do
      tags 'New Arrivals'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  color: { type: :string },
                  size: { type: :string },
                  price: { type: :number, format: :float },
                  photos: { type: :array, items: { type: :string } },
                  product_item: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      brand: { type: :string },
                      material: { type: :string },
                      created_at: { type: :string, format: 'date-time' }
                    }
                  }
                }
              }
            }
          },
          required: ['data']

        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string }
            }
          },
          required: ['errors']

        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_search' do
    get('search product items') do
      tags 'Search API'
      produces 'application/json'
      parameter name: :search, in: :query, type: :string, description: 'Search term for the product item name, brand, material'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page for pagination'
      response(200, 'successful') do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  brand: { type: :string },
                  price: { type: :number },
                  rating_and_review: { type: :string, nullable: true },
                  image: { type: :string, nullable: true }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                next_page: { type: :integer, nullable: true },
                prev_page: { type: :integer, nullable: true },
                total_pages: { type: :integer },
                total_count: { type: :integer }
              }
            }
          }
  
        let(:product_item) { create_list(:product_item, 10) }
        run_test!
      end
  
      response(404, 'not found') do
        schema type: :object,
          properties: {
            errors: { type: :array, items: { type: :string } }
          }
  
        let(:product_item) { [] }
        run_test!
      end
    end
  end
  
end
