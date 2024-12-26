require 'swagger_helper'

RSpec.describe 'Api::V2::Banners', type: :request do

  path '/api/v2/banners' do
    get('list banners') do
      tags 'Banners'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create banner') do
      tags 'Banners'
      consumes 'multipart/form-data'
      security [ bearerAuth2: [] ]
      
      parameter name: :banner, in: :formData, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string },
          banner_type: { type: :string },
          'images[]': { type: :array, items: { type: :string, format: :binary } }
        },
        required: [ 'heading', 'description', 'banner_type' ]
      }
      
      response(201, 'created') do
        let(:banner) { { heading: 'New Banner', description: 'This is a new banner.', banner_type: 'promo', images: [Rack::Test::UploadedFile.new('path/to/image1.jpg', 'image/jpeg')] } }
        run_test!
      end
    
      response(422, 'unprocessable entity') do
        let(:banner) { { heading: '', description: '', banner_type: '', images: [] } }
        run_test!
      end
    end    
  end

  path '/api/v2/banners/{id}' do
    parameter name: 'id', in: :path, banner_type: :string, description: 'id'

    get('show banner') do
      tags 'Banners'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { Banner.create(heading: 'Sample Banner', description: 'Sample Description', banner_type: 'promo').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update banner') do
      tags 'Banners'
      consumes 'multipart/form-data'
      security [ bearerAuth2: [] ]
    
      parameter name: :banner, in: :formData, schema: {
        type: :object,
        properties: {
          heading: { type: :string },
          description: { type: :string },
          banner_type: { type: :string },
          images: { type: :array, items: { type: :file } }
        }
      }
    
      response(200, 'successful') do
        let(:id) { Banner.create(heading: 'Sample Banner', description: 'Sample Description', banner_type: 'promo').id }
        let(:banner) { { heading: 'Updated Banner', description: 'Updated Description', images: [Rack::Test::UploadedFile.new('path/to/new_image1.jpg', 'image/jpeg')] } }
        run_test!
      end
    
      response(422, 'unprocessable entity') do
        let(:id) { Banner.create(heading: 'Sample Banner', description: 'Sample Description', banner_type: 'promo').id }
        let(:banner) { { heading: '', description: '', banner_type: '', images: [] } }
        run_test!
      end
    end    

    delete('delete banner') do
      tags 'Banners'
      security [ bearerAuth2: [] ]

      response(200, 'banner destroyed successfully') do
        let(:id) { Banner.create(heading: 'Sample Banner', description: 'Sample Description', banner_type: 'promo').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
