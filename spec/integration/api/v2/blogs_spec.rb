require 'swagger_helper'

RSpec.describe 'Api::V2::BlogsController', type: :request do
  path '/api/v2/blogs' do
    get 'Retrieves all blogs' do
      tags 'Blogs'
      produces 'application/json'
      response '200', 'Blogs listing' do
        run_test!
      end

      response '200', 'No blogs found' do
        run_test!
      end
    end

    post 'Creates a blog' do
      tags 'Blogs'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          category: { type: :string },
          card_home_url: { type: :string, nullable: true },
          card_insights_url: { type: :string, nullable: true },
          banner_url: { type: :string, nullable: true },
          body: { type: :string },
          visibility: { type: :boolean },
          publish_date: { type: :string, format: :date, nullable: true },
          publisher_id: { type: :integer },
          card_image: { type: :string, format: :binary, nullable: true },
          banner_image: { type: :string, format: :binary, nullable: true },
          card_home_image: { type: :string, format: :binary, nullable: true },
          description: { type: :string, nullable: true },
          path_name: { type: :string }
        },
        required: ['title', 'category', 'body', 'visibility', 'publisher_id', 'path_name']
      }
      response '201', 'Blog created successfully' do
        let(:blog) { { title: 'Sample Blog', category: 'Tech', body: 'Blog content here', visibility: true, publisher_id: 1, path_name: 'sample-blog' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:blog) { { title: nil } }
        run_test!
      end
    end
  end

  path '/api/v2/blogs/{path_name}' do
    parameter name: :path_name, in: :path, type: :string, description: 'Path name of the blog'

    get 'Retrieves a specific blog' do
      tags 'Blogs'
      produces 'application/json'
      response '200', 'Blog details' do
        let(:path_name) { 'sample-blog' }
        run_test!
      end

      response '404', 'Blog not found' do
        let(:path_name) { 'invalid-path' }
        run_test!
      end
    end

    patch 'Updates a specific blog' do
      tags 'Blogs'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          category: { type: :string },
          card_home_url: { type: :string, nullable: true },
          card_insights_url: { type: :string, nullable: true },
          banner_url: { type: :string, nullable: true },
          body: { type: :string },
          visibility: { type: :boolean },
          publish_date: { type: :string, format: :date, nullable: true },
          publisher_id: { type: :integer },
          card_image: { type: :string, format: :binary, nullable: true },
          banner_image: { type: :string, format: :binary, nullable: true },
          card_home_image: { type: :string, format: :binary, nullable: true },
          description: { type: :string, nullable: true },
          path_name: { type: :string }
        }
      }
      response '200', 'Blog updated successfully' do
        let(:path_name) { 'sample-blog' }
        let(:blog) { { title: 'Updated Blog Title', body: 'Updated content' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:path_name) { 'sample-blog' }
        let(:blog) { { title: nil } }
        run_test!
      end
    end

    delete 'Deletes a specific blog' do
      tags 'Blogs'
      security [bearerAuth: []]
      response '200', 'Blog deleted successfully' do
        let(:path_name) { 'sample-blog' }
        run_test!
      end

      response '404', 'Blog not found' do
        let(:path_name) { 'invalid-path' }
        run_test!
      end
    end
  end
end
