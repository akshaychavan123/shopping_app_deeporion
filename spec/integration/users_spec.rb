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

  path '/api/v1/users/user_details' do
    get 'Show User user_details' do
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


end