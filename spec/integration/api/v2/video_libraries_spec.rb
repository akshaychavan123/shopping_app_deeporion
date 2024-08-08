require 'swagger_helper'

RSpec.describe 'Api::V2::VideoLibrariesController', type: :request do
  path '/api/v2/video_libraries' do
    get 'Retrieves all Video Libraries' do
      tags 'Video Libraries'
      produces 'application/json'
      response '200', 'video_library found' do
        run_test!
      end
    end

    post 'Creates a Video Library' do
      tags 'Video Libraries'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :video_library, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          video_link: { type: :string }
        },
        required: ['description', 'video_link']
      }
      response '201', 'video_library created' do
        let(:video_library) { { description: 'Sample Video', video_link: 'http://example.com/video.mp4' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:video_library) { { description: nil, video_link: 'http://example.com/video.mp4' } }
        run_test!
      end
    end
  end

  path '/api/v2/video_libraries/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Retrieves a specific Video Library' do
      tags 'Video Libraries'
      produces 'application/json'
      response '200', 'video_library found' do
        let(:id) { VideoLibrary.create(description: 'Sample Video', video_link: 'http://example.com/video.mp4').id }
        run_test!
      end

      response '404', 'video_library not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a specific Video Library' do
      tags 'Video Libraries'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :video_library, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          video_link: { type: :string }
        },
        required: ['description', 'video_link']
      }
      response '200', 'video_library updated' do
        let(:id) { VideoLibrary.create(description: 'Sample Video', video_link: 'http://example.com/video.mp4').id }
        let(:video_library) { { description: 'Updated Video', video_link: 'http://example.com/updated_video.mp4' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { VideoLibrary.create(description: 'Sample Video', video_link: 'http://example.com/video.mp4').id }
        let(:video_library) { { description: nil } }
        run_test!
      end
    end

    delete 'Deletes a specific Video Library' do
      tags 'Video Libraries'
      security [bearerAuth2: []]
      response '204', 'video_library deleted' do
        let(:id) { VideoLibrary.create(description: 'Sample Video', video_link: 'http://example.com/video.mp4').id }
        run_test!
      end

      response '404', 'video_library not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '422', 'cannot delete video_library' do
        let(:video_library) { VideoLibrary.create(description: 'Sample Video', video_link: 'http://example.com/video.mp4') }
        let(:id) { video_library.id }
        before do
          allow_any_instance_of(VideoLibrary).to receive(:destroy).and_return(false)
          video_library.errors.add(:base, 'Cannot delete video_library entry')
        end
        run_test!
      end
    end
  end
end
