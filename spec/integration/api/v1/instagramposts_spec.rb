require 'swagger_helper'

RSpec.describe 'api/v1/instagramposts', type: :request do
  path '/api/v1/instagramposts' do
    get 'Retrieves all instagram posts' do
      tags 'Instagram'
      consumes 'application/json'
      security [bearerAuth: []]

      response '200', 'instagramposts retrieved' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    post 'Creates an instagramposts' do
      tags 'Instagram'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
            url: { type: :string },
            description: { type: :string },
            image: { type: :integer }
        },
        required: ['url']
      }

      response '201', 'address created' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:plan) { { name: 'Tessa' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:plan) { { name: 'Tessa' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:plan) { { name: 'Tessa' } }
        run_test!
      end
    end
  end

  path '/api/v1/instagramposts/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Plan ID'

    get 'Retrieves a specific instagramposts' do
      tags 'Instagram'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'instagramposts found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        run_test!
      end

      response '404', 'instagramposts not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        run_test!
      end
    end

    put 'Updates an instagramposts' do
      tags 'Instagram'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
          url: { type: :string },
          description: { type: :string },
          image: { type: :integer }
        }
      }

      response '200', 'instagramposts updated' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '404', 'instagramposts not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        let(:plan) { { plan: 'New City' } }
        run_test!
      end
    end

    delete 'Deletes an instagramposts' do
      tags 'Instagram'
      security [bearerAuth: []]

      response '200', 'instagramposts deleted' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        run_test!
      end

      response '404', 'instagramposts not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        run_test!
      end
    end
  end
end
