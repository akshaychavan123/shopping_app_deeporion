require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          terms_and_condition: { type: :boolean },
        },
        required: ['name', 'email', 'password', 'terms_and_condition']
      }

      response '201', 'user created' do
        let(:user) { { name: 'John', email: 'john@example.com', password: 'password', terms_and_condition: 'true' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'John' } }
        run_test!
      end
    end
  end

  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/users/{id}/update_image' do
    patch 'Update user image' do
      tags 'Users'
      security [bearerAuth: []]
      consumes 'multipart/form-data'
      parameter name: :image, in: :formData, schema: {type: :object,
      properties: {
        image: { type: :file }
      },
      required: ['image']}
      # parameter name: :image, in: :formData, type: :file, required: true, description: 'Image file to upload'

      response '200', 'Image updated' do
        let(:id) { user.id }
        let(:image) { fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpg') }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user.id }
        let(:image) { fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpg') }

        run_test!
      end

      response '422', 'Invalid params' do
        let(:id) { user.id }
        let(:image) { nil }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/delete_image' do
    delete 'Delete user image' do
      tags 'Users'
      security [bearerAuth: []]
      response '200', 'Image deleted' do
        let(:id) { user.id }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user.id }

        run_test!
      end

      response '422', 'Unprocessable entity' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/update_profile' do
    patch 'Update user profile' do
      tags 'Users'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :profile, in: :body, schema: {
        type: :object,
        properties: {
          bio: { type: :string },
          facebook_link: { type: :string },
          linkedin_link: { type: :string },
          instagram_link: { type: :string },
          youtube_link: { type: :string }
        }
      }

      response '200', 'Profile updated' do
        let(:profile) { { bio: 'Updated bio', facebook_link: 'https://facebook.com/user', linkedin_link: 'https://linkedin.com/in/user', instagram_link: 'https://instagram.com/user', youtube_link: 'https://youtube.com/user' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:profile) { { bio: 'Updated bio' } }
        run_test!
      end

      response '422', 'Invalid params' do
        let(:profile) { { bio: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/show_profile' do
    get 'Show User Profile' do
      tags 'Users'
      security [bearerAuth: []]
      response '200', 'Profile data' do
        let(:id) { user.id }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { user.id }

        run_test!
      end

      response '422', 'Unprocessable entity' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/update_address' do
    patch 'Update user address' do
      tags 'Users'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              address: { type: :string },
              city: { type: :string },
              state: { type: :string },
              country: { type: :string },
              pincode: { type: :string },
              area: { type: :string },
              address_type: { type: :string },
              phone_number: { type: :string },
              email: { type: :string }
            },
            required: ['first_name', 'last_name', 'address', 'city', 'state', 'country', 'pincode', 'area', 'address_type', 'phone_number', 'email']
          }
        }
      }
  
      response '200', 'Address updated' do
        let(:user) { { user: { first_name: 'Tessa', last_name: 'Rain', address: '19f Abhinay Theatre Complex, bvk Iyengar Street', city: 'Bangalore', state: 'Karnataka', country: 'India', pincode: '560009', area: 'bvk Iyengar Street', address_type: 'Home', phone_number: '+91 1234567890', email: 'tessarain@gmail.com' } } }
        run_test!
      end
  
      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        let(:user) { { user: { first_name: 'Tessa', last_name: 'Rain' } } }
        run_test!
      end
  
      response '422', 'Invalid params' do
        let(:user) { { user: { first_name: '', last_name: '' } } }
        run_test!
      end
    end
  end  
end