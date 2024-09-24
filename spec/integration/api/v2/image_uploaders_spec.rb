require 'swagger_helper'

RSpec.describe 'Api::V2::ImageUploaders', type: :request do
  path '/api/v2/image_uploaders/images_by_name' do
    get 'Get images by name' do
      tags 'Image Uploaders'
      produces 'application/json'
      parameter name: :name, in: :query, type: :string, description: 'Image name'

      response '200', 'images found' do
        let!(:image_uploader) { create(:image_uploader, name: 'test_name') }
        let(:name) { 'test_name' }

        run_test!
      end

      response '404', 'images not found' do
        let(:name) { 'unknown_name' }
        run_test!
      end
    end
  end

  path '/api/v2/image_uploaders/{id}' do
    get 'Retrieve an image uploader by ID' do
      tags 'Image Uploaders'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ImageUploader ID'

      response '200', 'image uploader found' do
        let(:id) { create(:image_uploader).id }
        run_test!
      end

      response '404', 'image uploader not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    delete 'Delete an image uploader by ID' do
      tags 'Image Uploaders'
      produces 'application/json'
      security [ bearerAuth2: [] ]
      parameter name: :id, in: :path, type: :integer, description: 'ImageUploader ID'

      response '200', 'image uploader deleted' do
        let(:id) { create(:image_uploader).id }
        run_test!
      end

      response '404', 'image uploader not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end

  path '/api/v2/image_uploaders' do
    post 'Create an image uploader' do
      tags 'Image Uploaders'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [ bearerAuth2: [] ]  
      
      parameter name: :image_uploader, in: :formData, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          images: { type: :array, items: { type: :string, format: :binary } }
        },
        required: [ 'name', 'images' ]
      }

      response '201', 'image uploader created' do
        let(:image_uploader) do
          {
            name: 'test_image',
            images: [fixture_file_upload('spec/fixtures/sample_image.jpg', 'image/jpeg')]
          }
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:image_uploader) { { name: '', images: [] } }
        run_test!
      end
    end
  end
end
