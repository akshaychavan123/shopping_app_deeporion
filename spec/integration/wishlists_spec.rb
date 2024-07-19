require 'swagger_helper'

RSpec.describe 'api/v1/wishlists', type: :request do
  let(:user) { create(:user) }
  let(:wishlist) { create(:wishlist, user: user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/wishlists/show_wishlistitems' do

    get('show wishlist') do
      tags 'Wishlists'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'successful') do
        let(:user_id) { user.id }
        run_test!
      end

      response(404, 'not found') do
        let(:user_id) { 'invalid' }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:user_id) { user.id }
        run_test!
      end
    end
  end
end
