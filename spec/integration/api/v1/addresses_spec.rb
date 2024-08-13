require 'swagger_helper'

RSpec.describe 'api/v1/addresses', type: :request do
  path '/api/v1/addresses' do
    get 'Retrieves all Addresses' do
      tags 'Addresses'
      consumes 'application/json'
      security [bearerAuth: []]

      response '200', 'addresses retrieved' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

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

  path '/api/v1/addresses/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Address ID'

    get 'Retrieves a specific Address' do
      tags 'Addresses'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'address found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:address, user: @user).id }
        run_test!
      end

      response '404', 'address not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:address).id }
        run_test!
      end
    end

    put 'Updates an Address' do
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
        }
      }

      response '200', 'address updated' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:address, user: @user).id }
        let(:address) { { city: 'New City' } }
        run_test!
      end

      response '404', 'address not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        let(:address) { { city: 'New City' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:address).id }
        let(:address) { { city: 'New City' } }
        run_test!
      end
    end

    delete 'Deletes an Address' do
      tags 'Addresses'
      security [bearerAuth: []]

      response '200', 'address deleted' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:address, user: @user).id }
        run_test!
      end

      response '404', 'address not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:address).id }
        run_test!
      end
    end
  end
end
