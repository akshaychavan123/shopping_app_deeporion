require 'swagger_helper'

RSpec.describe 'Api::V2::AboutUsController', type: :request do
  path '/api/v2/about_us' do
    get 'Retrieves all About Us entries' do
      tags 'About Us'
      produces 'application/json'
      response '200', 'about us found' do
        run_test!
      end
    end

    post 'Creates an About Us entry' do
      tags 'About Us'
      consumes 'multipart/form-data'
      security [bearerAuth2: []]
      parameter name: :about_us, in: :formData, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string },
          "images[]": { type: :array, items: { type: :string, format: :binary } }
        },
        required: ['heading', 'description']
      }
      response '201', 'about us created' do
        let(:about_us) { { heading: 'Our Mission', description: 'To provide the best services.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:about_us) { { heading: nil, description: 'To provide the best services.' } }
        run_test!
      end
    end
  end

  path '/api/v2/about_us/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Retrieves a specific About Us entry' do
      tags 'About Us'
      produces 'application/json'
      response '200', 'about us found' do
        let(:id) { AboutUs.create(heading: 'Our Mission', description: 'To provide the best services.').id }
        run_test!
      end

      response '404', 'about us not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a specific About Us entry' do
      tags 'About Us'
      consumes 'multipart/form-data'
      security [bearerAuth2: []]
      parameter name: :about_us, in: :formData, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string },
          'images[]': {
              type: :array,
              items: { type: :string, format: :binary }
            }
        },
      }
      response '200', 'about us updated' do
        let(:id) { AboutUs.create(heading: 'Our Mission', description: 'To provide the best services.').id }
        let(:about_us) { { heading: 'Updated Mission', description: 'To provide the best services ever.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { AboutUs.create(heading: 'Our Mission', description: 'To provide the best services.').id }
        let(:about_us) { { heading: nil } }
        run_test!
      end
    end

    delete 'Deletes a specific About Us entry' do
      tags 'About Us'
      security [bearerAuth2: []]
      response '204', 'about us deleted' do
        let(:id) { AboutUs.create(heading: 'Our Mission', description: 'To provide the best services.').id }
        run_test!
      end

      response '404', 'about us not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
