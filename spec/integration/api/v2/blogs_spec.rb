require 'swagger_helper'

RSpec.describe 'Api::V2::BlogsController', type: :request do
  path '/api/v2/blogs' do
    get 'Retrieves all blogs' do
      tags 'Blogs'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Number of blogs per page'
      parameter name: :query, in: :query, type: :string, required: false, description: 'Search query for blogs (path_name, publisher name, or email)'

      response '200', 'Blogs listing' do
        run_test!
      end

      response '200', 'No blogs found' do
        run_test!
      end
    end

    post 'Creates a blog' do
      tags 'Blogs'
      consumes 'multipart/form-data'
      security [bearerAuth: []]
      parameter name: :blog, in: :formData, schema: {
        type: :object,
        properties: {
          'blog[title]': { type: :string },
          'blog[category]': { type: :string },
          'blog[card_home_url]': { type: :string, nullable: true },
          'blog[card_insights_url]': { type: :string, nullable: true },
          'blog[banner_url]': { type: :string, nullable: true },
          'blog[body]': { type: :string },
          'blog[visibility]': { type: :boolean },
          'blog[publish_date]': { type: :string, format: :date, nullable: true },
          'blog[publisher_id]': { type: :integer },
          'blog[card_home_url_alt]': { type: :string, nullable: true },
          'blog[card_insights_url_alt]': { type: :string, nullable: true },
          'blog[banner_url_alt]': { type: :string, nullable: true },
          'blog[description]': { type: :string, nullable: true },
          'blog[path_name]': { type: :string }
        },
        required: ['blog[title]', 'blog[category]', 'blog[body]', 'blog[visibility]', 'blog[publisher_id]', 'blog[path_name]']
      }
      response '201', 'Blog created successfully' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end
    end
  end

  path '/api/v2/blogs/show_blog' do
    get 'Retrieves a specific blog' do
      tags 'Blogs'
      produces 'application/json'
      parameter name: :path_name, in: :query, type: :string, description: 'Path name of the blog', required: true

      response '200', 'Blog details' do
        let(:path_name) { 'sample-blog' }
        run_test!
      end

      response '404', 'Blog not found' do
        let(:path_name) { 'invalid-path' }
        run_test!
      end
    end
  end

  path '/api/v2/blogs/update_blog' do
    put 'Updates a specific blog' do
      tags 'Blogs'
      consumes 'multipart/form-data'
      security [bearerAuth: []]
      parameter name: :blog, in: :formData, schema: {
        type: :object,
        properties: {
          'blog[title]': { type: :string },
          'blog[category]': { type: :string },
          'blog[card_home_url]': { type: :string, nullable: true },
          'blog[card_insights_url]': { type: :string, nullable: true },
          'blog[banner_url]': { type: :string, nullable: true },
          'blog[body]': { type: :string },
          'blog[visibility]': { type: :boolean },
          'blog[publish_date]': { type: :string, format: :date, nullable: true },
          'blog[publisher_id]': { type: :integer },
          'blog[card_home_url_alt]': { type: :string, nullable: true },
          'blog[card_insights_url_alt]': { type: :string, nullable: true },
          'blog[banner_url_alt]': { type: :string, nullable: true },
          'blog[description]': { type: :string, nullable: true },
          'blog[path_name]': { type: :string }
        },
        required: ['blog[title]', 'blog[category]', 'blog[body]', 'blog[visibility]', 'blog[publisher_id]', 'blog[path_name]']
      }
      response '200', 'Blog updated successfully' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end
    end
  end

  path '/api/v2/blogs/delete_blog' do
    delete 'Deletes a specific blog' do
      tags 'Blogs'
      security [bearerAuth: []]
      parameter name: :path_name, in: :query, type: :string, required: true, description: 'Path name of the blog'

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

