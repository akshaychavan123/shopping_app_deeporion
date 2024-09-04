require 'swagger_helper'

RSpec.describe 'Api::V2::VideoDescriptions', type: :request do

  path '/api/v2/video_descriptions' do
    get('list video descriptions') do
      tags 'VideoDescriptions'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create video description') do
      tags 'VideoDescriptions'
      consumes 'application/json'
      security [bearerAuth2: []]

      parameter name: :video_description, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        },
        required: ['description']
      }

      response(201, 'created') do
        let(:video_description) { { description: 'New video description' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:video_description) { { description: '' } }
        run_test!
      end
    end
  end

  path '/api/v2/video_descriptions/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'ID of the video description'

    get('show video description') do
      tags 'VideoDescriptions'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { VideoDescription.create(description: 'Sample video description').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update video description') do
      tags 'VideoDescriptions'
      consumes 'application/json'
      security [bearerAuth2: []]

      parameter name: :video_description, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { VideoDescription.create(description: 'Sample video description').id }
        let(:video_description) { { description: 'Updated video description' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { VideoDescription.create(description: 'Sample video description').id }
        let(:video_description) { { description: '' } }
        run_test!
      end
    end

    delete('delete video description') do
      tags 'VideoDescriptions'
      security [bearerAuth2: []]

      response(200, 'successful') do
        let(:id) { VideoDescription.create(description: 'Sample video description').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
