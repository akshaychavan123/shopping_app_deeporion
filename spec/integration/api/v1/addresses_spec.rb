require 'swagger_helper'

RSpec.describe 'api/v1/addresses', type: :request do
  path '/api/v1/addresses' do
    post 'Creates an Address' do
      tags 'Addresses'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :address, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          phone_number: { type: :string },
          email: { type: :string, format: :email },
          country: { type: :string },
          pincode: { type: :string },
          area: { type: :string },
          state: { type: :string },
          address: { type: :string },
          city: { type: :string },
          address_type: { type: :string },
          default: { type: :boolean }
        },
        required: ['first_name', 'last_name', 'phone_number', 'email', 'country', 'pincode', 'area', 'state', 'address', 'city', 'address_type']
      }

      response '201', 'address created' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:address) { { first_name: 'Tessa', last_name: 'Rain', phone_number: '+91 1234567890', email: 'tessarain@gmail.com', country: 'India', pincode: '560009', area: 'bvk Iyengar Street', state: 'Karnataka', address: '19f Abhinay Theatre Complex, bvk Iyengar Street', city: 'Bangalore', address_type: 'home', default: true } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:address) { { first_name: 'Tessa' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:address) { { first_name: 'Tessa', last_name: 'Rain', phone_number: '+91 1234567890', email: 'tessarain@gmail.com', country: 'India', pincode: '560009', area: 'bvk Iyengar Street', state: 'Karnataka', address: '19f Abhinay Theatre Complex, bvk Iyengar Street', city: 'Bangalore', address_type: 'home', default: true } }
        run_test!
      end
    end
  end
end
