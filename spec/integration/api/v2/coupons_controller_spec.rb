require 'swagger_helper'

RSpec.describe 'Api::V2::Coupons', type: :request do
  let(:token) { JsonWebToken.encode(user_id: create(:user).id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v2/coupons' do
    get('list coupons') do
      tags 'Coupons'
      security [bearerAuth2: []]
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create coupon') do
      tags 'Coupons'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'
      
      parameter name: :coupon, in: :formData, schema: {
        type: :object,
        properties: {
          promo_code_name: { type: :string },
          promo_code: { type: :string },
          start_date: { type: :string, format: :date },
          end_date: { type: :string, format: :date },
          promo_type: { type: :string, enum: ['discount_on_product', 'discount_on_amount'] },
          discount_type: { type: :string, enum: ['amount', 'percentage'] },
          max_purchase: { type: :number },
          amount_off: { type: :number, format: :float },
          max_uses_per_client: { type: :integer },
          max_uses_per_promo: { type: :integer },
          product_ids: { type: :array, items: { type: :integer } },
          image: { type: :string, format: :binary }
        },
        required: ['promo_code_name', 'promo_code', 'start_date', 'end_date', 'promo_type', 'amount_off', 'discount_type']
      }

      response(201, 'created') do
        let(:coupon) do
          {
            promo_code_name: '50% OFF',
            promo_code: 'SALE50',
            start_date: '2024-07-22',
            end_date: '2024-07-30',
            promo_type: 'discount_on_amount',
            amount_off: 50.0,
            max_uses_per_client: 10,
            max_uses_per_promo: 100,
            image: [
              Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
            ]
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:coupon) { { promo_code_name: nil } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:coupon) { { promo_code_name: '50% OFF' } }
        run_test!
      end
    end
  end

  path '/api/v2/coupons/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the coupon'

    get('show coupon') do
      tags 'Coupons'
      security [bearerAuth2: []]
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update coupon') do
      tags 'Coupons'
      security [bearerAuth2: []]
      consumes 'multipart/form-data'
      
      parameter name: :coupon, in: :formData, schema: {
        type: :object,
        properties: {
          promo_code_name: { type: :string },
          promo_code: { type: :string },
          start_date: { type: :string, format: :date },
          end_date: { type: :string, format: :date },
          promo_type: { type: :string, enum: ['discount_on_product', 'discount_on_amount'] },
          discount_type: { type: :string, enum: ['amount', 'percentage'] },
          max_purchase: { type: :number },
          amount_off: { type: :number, format: :float },
          max_uses_per_client: { type: :integer },
          max_uses_per_promo: { type: :integer },
          product_ids: { type: :array, items: { type: :integer } },
          image: { type: :string, format: :binary }
        },
        required: ['promo_code_name', 'promo_code', 'start_date', 'end_date', 'promo_type', 'amount_off','discount_type']
      }

      response(200, 'successful') do
        let(:id) { create(:coupon).id }
        let(:coupon) do
          {
            promo_code_name: 'Updated Promo',
            promo_code: 'NEWCODE',
            start_date: '2024-08-01',
            end_date: '2024-08-10',
            promo_type: 'discount_on_product',
            amount_off: 20.0,
            max_uses_per_client: 5,
            max_uses_per_promo: 50,
            product_ids: [1, 2],
            image: [
              Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
            ]
          }
        end
        run_test!
      end
    end

    delete('delete coupon') do
      tags 'Coupons'
      security [bearerAuth2: []]
      consumes 'application/json'

      response(200, 'successful') do
        let(:id) { create(:coupon).id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end

  path '/api/v2/coupons/{id}/product_list' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the coupon'
  
    get('list associated products') do
      tags 'Coupons'
      security [bearerAuth2: []]
      consumes 'application/json'
  
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer },
                     next_page: { type: :integer },
                     prev_page: { type: :integer },
                     total_pages: { type: :integer },
                     total_count: { type: :integer }
                   }
                 }
               }
        run_test!
      end
  
      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end  
end
