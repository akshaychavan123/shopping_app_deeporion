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
        schema type: :array, items: { '$ref' => '#/components/schemas/Coupon' }
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
          promo_type: { type: :string },
          amount_off: { type: :number, format: :float },
          max_uses_per_client: { type: :integer },
          max_uses_per_promo: { type: :integer },
          couponable_id: { type: :integer },
          couponable_type: { type: :string },
          image: { type: :string, format: :binary }
        },
        required: ['promo_code_name', 'promo_code', 'start_date', 'end_date', 'promo_type', 'amount_off']
      }

      response(201, 'created') do
        let(:coupon) do
          {
            promo_code_name: '50% OFF',
            promo_code: 'SALE50',
            start_date: '2024-07-22',
            end_date: '2024-07-30',
            discount: 50.0,
            promo_type: 'Discount on amount',
            amount_off: 50.0,
            max_uses_per_client: 10,
            max_uses_per_promo: 100,
            couponable_id: create(:product).id,
            couponable_type: 'Product',
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
        schema '$ref' => '#/components/schemas/Coupon'
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v2/coupons/{id}/products' do
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
