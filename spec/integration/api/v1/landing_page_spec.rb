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
      security [bearerAuth: []]
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

  path '/api/v1/landing_page/product_items_by_sub_category/{id}' do
    get('Get product items by subcategory') do
      tags 'Landing Page'
      description 'Fetches all product items associated with a specific subcategory.'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :id, in: :path, type: :integer, description: 'ID of the subcategory to fetch product items for', required: true
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'
  
      response(200, 'successful') do
        let(:id) { create(:subcategory).id }
        run_test!
      end
  
      response(404, 'subcategory not found') do
        let(:id) { 'invalid' }
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

  path '/api/v1/landing_page/gift_cards_category' do
    get('list gift_card_categories') do
      tags 'GiftCardCategoriesAll'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/recent_viewed_product_items' do
    get('list recent viewed product items') do
      tags 'Landing Page'
      produces 'application/json'
      security [bearerAuth: []]

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/gift_cards_by_category/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the GiftCardCategory'
    get('list gift_card_categories') do
      tags 'GiftCardByCategories'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/landing_page/product_items_of_product/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the product'
    parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
    parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'  

    get('retrieve product_item') do
      tags 'Landing Page'
      produces 'application/json'
      security [bearerAuth: []]

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
      security [bearerAuth: []]

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
      security [bearerAuth: []]
  
      parameter name: :category_id, in: :query, type: :integer, description: 'ID of the Category', required: true
      parameter name: :subcategory_ids, in: :query, type: :array, items: { type: :integer }, description: 'IDs of the subcategories'
      parameter name: :product_ids, in: :query, type: :array, items: { type: :integer }, description: 'IDs of the products'
      parameter name: :brands, in: :query, type: :array, items: { type: :string }, description: 'Brands of the product items'
      parameter name: :sizes, in: :query, type: :array, items: { type: :string }, description: 'Sizes of the product items'
      parameter name: :colors, in: :query, type: :array, items: { type: :string }, description: 'Colors of the product items'
      parameter name: :price_ranges, in: :query, type: :array, items: { type: :string }, description: 'Price ranges in the format "min-max"'
      parameter name: :search, in: :query, type: :string, description: 'Search term for the product item name, brand, color, or material'
      parameter name: :sort_by, in: :query, type: :string, description: 'Sort for the product item Recommended, What New, Popularity, Better Discount, Price:High to Low, Price: Low to High, Customer Rating'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'
  
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
               required: ['data']
  
        let(:category_id) { 1 }
        let(:subcategory_ids) { [1, 2] }
        let(:product_ids) { [1, 2, 3] }
        let(:brands) { ['Brand1', 'Brand2'] }
        let(:sizes) { ['M', 'L'] }
        let(:colors) { ['red', 'blue'] }
        let(:price_ranges) { ['0-50', '51-100'] }
        let(:search) { 'shirt' }
  
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
  
      response(422, 'unprocessable entity') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               },
               required: ['errors']
  
        let(:search) { ' ' }
  
        run_test!
      end
    end
  end  

  path '/api/v1/landing_page/new_arrivals' do
    get('new arrivals') do
      tags 'New Arrivals'
      produces 'application/json'
      security [bearerAuth: []]

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

  path '/api/v1/landing_page/top_category' do
    get('top category') do
      tags 'Landing Page'
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
                  name: { type: :string },
                  image: { type: :string, format: :uri },
                  subcategory: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      name: { type: :string }
                    },
                    required: ['id', 'name']
                  }
                },
                required: ['id', 'name', 'image', 'subcategory']
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
      security [bearerAuth: []]
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
  
  path '/api/v1/landing_page/filter_data_for_mobile' do
    get('filter data for mobile') do
      tags 'Landing Page'
      produces 'application/json'
      security [bearerAuth: []]
  
      parameter name: :category_id, in: :query, type: :integer, description: 'ID of the Category'
      parameter name: :subcategory_ids, in: :query, type: :string, description: 'Comma-separated list of Subcategory IDs'
      parameter name: :product_ids, in: :query, type: :string, description: 'Comma-separated list of Product IDs to fetch variant names and unique colors'
  
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 categories: { type: :array, items: { type: :object } },
                 subcategories: { type: :array, items: { type: :object } },
                 products: { type: :array, items: { type: :object } },
                 unique_colors: { type: :array, items: { type: :string } },
                 variant_names: { type: :array, items: { type: :string } }
               },
               required: %w[categories subcategories products unique_colors variant_names]
        run_test!
      end
  
      response(404, 'not found') do
        run_test!
      end
    end
  end  
end
